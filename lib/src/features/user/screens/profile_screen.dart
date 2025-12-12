import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/core/models/user_profile.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firebaseService = FirebaseService();
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: StreamBuilder<UserProfile?>(
  stream: _firebaseService.getUserProfile(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
        if (!snapshot.hasData || snapshot.data == null) {
  return const Center(child: Text('No profile data found.'));
}

final userProfile = snapshot.data!;


          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email: ${_currentUser?.email ?? "Not signed in"}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  'Preferences',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 15),
                _buildPreferenceList('Liked Foods', userProfile.likedFoods),
                _buildPreferenceList(
                  'Disliked Foods',
                  userProfile.dislikedFoods,
                ),
                _buildPreferenceList('Allergies', userProfile.allergies),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () => context.go('/food-preferences'),
                    child: const Text('Update Food Preferences'),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await _firebaseService.signOut();
                      if (!mounted) return;
                      context.go('/'); // Navigate to AuthGate
                    },
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreferenceList(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        items.isEmpty
            ? Text(
                'None specified',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              )
            : Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: items
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ))
                    .toList(),
              ),
        const SizedBox(height: 15),
      ],
    );
  }
}
