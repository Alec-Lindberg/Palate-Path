import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/core/models/user_profile.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:palate_path/src/data/seed_recipes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();
    final currentUser = FirebaseAuth.instance.currentUser;
    final seedService = SeedService();

    // If not logged in, send user back to auth entry.
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to Login'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder(
        future: firebaseService.getData(
          collectionPath: 'userProfiles',
          documentPath: currentUser.uid,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email: ${currentUser.email ?? "Not available"}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  const Text('No profile data found yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/food-preferences'),
                    child: const Text('Set Food Preferences'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      await firebaseService.signOut();
                      if (!context.mounted) return;
                      context.go('/');
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final userProfile = UserProfile.fromFirestore(data);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email: ${currentUser.email ?? "Not available"}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  'Preferences',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),

                _PreferenceChips(title: 'Liked Foods', items: userProfile.likedFoods),
                _PreferenceChips(title: 'Disliked Foods', items: userProfile.dislikedFoods),
                _PreferenceChips(title: 'Allergies', items: userProfile.allergies),

                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.go('/food-preferences'),
                  child: const Text('Update Food Preferences'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () async {
                    await firebaseService.signOut();
                    if (!context.mounted) return;
                    context.go('/');
                  },
                  child: const Text('Sign Out'),
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () async {
                    await seedService.seedRecipes(overwrite: true);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Recipe images re-seeded.')),
                      );
                    }
                  },
                  child: const Text('Reseed Images (Debug)'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PreferenceChips extends StatelessWidget {
  final String title;
  final List<String> items;

  const _PreferenceChips({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Text(
              'None specified',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: items.map((item) => Chip(label: Text(item))).toList(),
            ),
        ],
      ),
    );
  }
}
