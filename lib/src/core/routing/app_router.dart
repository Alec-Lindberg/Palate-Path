import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/features/auth/screens/auth_gate.dart';
import 'package:palate_path/src/features/onboarding/screens/food_preferences_screen.dart';
import 'package:palate_path/src/features/profile/screens/profile_screen.dart';
import 'package:palate_path/src/features/recipes/screens/favorites_screen.dart';
import 'package:palate_path/src/features/recipes/screens/home_screen.dart';
import 'package:palate_path/src/features/recipes/screens/recipe_detail_screen.dart';
import 'package:palate_path/src/features/shell/screens/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthGate()),
    GoRoute(
      path: '/food-preferences',
      builder: (context, state) => const FoodPreferencesScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  RecipeDetailScreen(recipeId: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
