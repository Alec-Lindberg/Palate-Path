import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String userId;
  final List<String> likedFoods;
  final List<String> dislikedFoods;
  final List<String> allergies;

  UserProfile({
    required this.userId,
    required this.likedFoods,
    required this.dislikedFoods,
    required this.allergies,
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      userId: data['userId'] ?? '',
      likedFoods: List<String>.from(data['likedFoods'] ?? []),
      dislikedFoods: List<String>.from(data['dislikedFoods'] ?? []),
      allergies: List<String>.from(data['allergies'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'likedFoods': likedFoods,
      'dislikedFoods': dislikedFoods,
      'allergies': allergies,
    };
  }
}
