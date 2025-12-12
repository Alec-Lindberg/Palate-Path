import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:palate_path/src/core/models/recipe.dart';
import 'package:palate_path/src/core/models/user_profile.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ---------------------------
  // Generic helpers
  // ---------------------------
  Future<void> addData({
    required String collectionPath,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collectionPath).add(data);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData({
    required String collectionPath,
    required String documentPath,
  }) async {
    return _firestore.collection(collectionPath).doc(documentPath).get();
  }

  Future<void> setData({
    required String collectionPath,
    required String documentPath,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    await _firestore
        .collection(collectionPath)
        .doc(documentPath)
        .set(data, SetOptions(merge: merge));
  }

  // ---------------------------
  // Auth helpers
  // ---------------------------
  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<void> signOut() async {
    await _auth.signOut();
  }
Future<User?> signUpWithEmailPassword(String email, String password) async {
  final cred = await _auth.createUserWithEmailAndPassword(
    email: email.trim(),
    password: password.trim(),
  );
  return cred.user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  final cred = await _auth.signInWithEmailAndPassword(
    email: email.trim(),
    password: password.trim(),
  );
  return cred.user;
}

/// Creates a basic profile doc if it doesn't exist yet.
/// This keeps AuthGate + onboarding logic working.
Future<void> createUserProfile(String userId, String email) async {
  final ref = _firestore.collection('userProfiles').doc(userId);
  final doc = await ref.get();

  if (doc.exists) return;

  await ref.set({
    'userId': userId,
    'email': email,
    'likedFoods': <String>[],
    'dislikedFoods': <String>[],
    'allergies': <String>[],
    'createdAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}

  // ---------------------------
  // User Profile
  // Assumes Firestore doc id == uid in collection: userProfiles
  // and UserProfile.fromFirestore(Map<String,dynamic>) exists
  // ---------------------------
  Stream<UserProfile?> getUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('userProfiles')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      final data = snapshot.data();
      if (data == null) return null;
      return UserProfile.fromFirestore(data);
    });
  }

  // Convenience: create/update profile
  Future<void> upsertUserProfile(UserProfile profile) async {
    await _firestore
        .collection('userProfiles')
        .doc(profile.userId)
        .set(profile.toFirestore(), SetOptions(merge: true));
  }

  // ---------------------------
  // Recipes
  // Assumes Recipe.fromFirestore(Map<String,dynamic> data, String id) exists
  // ---------------------------
  Stream<List<Recipe>> getRecipes() {
    return _firestore.collection('recipes').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Recipe.fromFirestore(doc.data(), doc.id))
          .toList();
    });
  }

  Stream<Recipe?> getRecipe(String recipeId) {
    return _firestore
        .collection('recipes')
        .doc(recipeId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return Recipe.fromFirestore(data, doc.id);
    });
  }

  // ---------------------------
  // Favorites
  // Collection: userRecipeStatus
  // Doc id: {uid}_{recipeId}
  // ---------------------------
  Stream<bool> isRecipeFavorited(String recipeId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    final docId = '${user.uid}_$recipeId';
    return _firestore
        .collection('userRecipeStatus')
        .doc(docId)
        .snapshots()
        .map((snap) => (snap.data()?['isFavorite'] as bool?) ?? false);
  }

  Future<void> toggleFavorite(String recipeId, bool nextValue) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docId = '${user.uid}_$recipeId';
    await _firestore.collection('userRecipeStatus').doc(docId).set({
      'userId': user.uid,
      'recipeId': recipeId,
      'isFavorite': nextValue,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<String>> favoriteRecipeIds() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('userRecipeStatus')
        .where('userId', isEqualTo: user.uid)
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => d.data()['recipeId'] as String).toList());
  }

  Stream<List<Recipe>> getFavoriteRecipes() {
    // Fetch recipes then filter using favorite ids stream.
    // (Avoids Firestore whereIn limit issues and is simpler for MVP.)
    return favoriteRecipeIds().asyncExpand((ids) {
      if (ids.isEmpty) return Stream.value(<Recipe>[]);
      return getRecipes().map((recipes) =>
          recipes.where((r) => ids.contains(r.id)).toList());
    });
  }
}
