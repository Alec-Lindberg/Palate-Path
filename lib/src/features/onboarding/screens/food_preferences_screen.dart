import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/core/models/user_profile.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodPreferencesScreen extends StatefulWidget {
  const FoodPreferencesScreen({super.key});

  @override
  State<FoodPreferencesScreen> createState() => _FoodPreferencesScreenState();
}

class _FoodPreferencesScreenState extends State<FoodPreferencesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> _foodOptions = [
    'Italian',
    'Mexican',
    'Chinese',
    'Indian',
    'Japanese',
    'Thai',
    'Vietnamese',
    'Korean',
    'American',
    'Mediterranean',
  ];

  final List<String> _allergyOptions = [
    'Milk (dairy)',
    'Eggs',
    'Peanuts',
    'Tree nuts',
    'Wheat/Gluten',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
  ];

  List<String> _likedFoods = [];
  List<String> _dislikedFoods = [];
  List<String> _allergies = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final user = _firebaseService.currentUser;
    if (user == null) return;

    final doc =
        await _firebaseService.getData(
              collectionPath: 'userProfiles',
              documentPath: user.uid,
            )
            as DocumentSnapshot;

    if (doc.exists && doc.data() != null) {
      final userProfile = UserProfile.fromFirestore(
        doc.data() as Map<String, dynamic>,
      );
      setState(() {
        _likedFoods = userProfile.likedFoods;
        _dislikedFoods = userProfile.dislikedFoods;
        _allergies = userProfile.allergies;
      });
    }
  }

  void _toggleSelection(String item, List<String> list) {
    setState(() {
      if (list.contains(item)) {
        list.remove(item);
      } else {
        list.add(item);
      }
    });
  }

  Future<void> _savePreferences() async {
    final user = _firebaseService.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error: Not logged in.')));
      }
      return;
    }

    final userId = user.uid;
    final userProfile = UserProfile(
      userId: userId,
      likedFoods: _likedFoods,
      dislikedFoods: _dislikedFoods,
      allergies: _allergies,
    );

    try {
      await _firebaseService.setData(
        collectionPath: 'userProfiles',
        documentPath: userId,
        data: userProfile.toFirestore(),
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Preferences saved')));
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving preferences: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Preferences')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Liked Foods',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _foodOptions
                    .map(
                      (food) => FilterChip(
                        label: Text(food),
                        selected: _likedFoods.contains(food),
                        onSelected: (selected) {
                          _toggleSelection(food, _likedFoods);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text(
                'Disliked Foods',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _foodOptions
                    .map(
                      (food) => FilterChip(
                        label: Text(food),
                        selected: _dislikedFoods.contains(food),
                        onSelected: (selected) {
                          _toggleSelection(food, _dislikedFoods);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              Text('Allergies', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                children: _allergyOptions
                    .map(
                      (allergy) => FilterChip(
                        label: Text(allergy),
                        selected: _allergies.contains(allergy),
                        onSelected: (selected) {
                          _toggleSelection(allergy, _allergies);
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  child: const Text('Save Preferences'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
