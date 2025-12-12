import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/features/auth/screens/auth_screen.dart';
import 'package:palate_path/src/features/onboarding/screens/food_preferences_screen.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseService = FirebaseService();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (!authSnap.hasData) {
          return const AuthScreen();
        }

        return StreamBuilder(
          stream: firebaseService.getUserProfile(),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // If profile doc doesn't exist yet => send to onboarding
            if (!profileSnap.hasData || profileSnap.data == null) {
              return const FoodPreferencesScreen();
            }

            // Profile exists => go to home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/home');
            });

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}

