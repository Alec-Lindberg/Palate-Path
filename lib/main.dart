import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';

import 'package:palate_path/firebase_options.dart';
import 'package:palate_path/src/core/theme/theme.dart';
import 'package:palate_path/src/data/seed_recipes.dart';

import 'package:palate_path/src/features/auth/screens/auth_screen.dart';
import 'package:palate_path/src/features/onboarding/screens/food_preferences_screen.dart';
import 'package:palate_path/src/features/profile/screens/profile_screen.dart';
import 'package:palate_path/src/features/recipes/screens/favorites_screen.dart';
import 'package:palate_path/src/features/recipes/screens/home_screen.dart';
import 'package:palate_path/src/features/recipes/screens/recipe_detail_screen.dart';
import 'package:palate_path/src/features/shell/screens/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent: [core/duplicate-app] A Firebase App named "[DEFAULT]" already exists
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const PalatePathApp());

  // Seed AFTER first frame so startup isn't blocked (debug only).
  if (kDebugMode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SeedService().seedRecipes(); // intentionally not awaited
    });
  }
}

class PalatePathApp extends StatelessWidget {
  const PalatePathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Palate Path',
      theme: appTheme,
      // no darkTheme
      routerConfig: _router,
    );
  }
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  routes: [
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/food-preferences',
      builder: (context, state) => const FoodPreferencesScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: ':id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => RecipeDetailScreen(
                recipeId: state.pathParameters['id']!,
              ),
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


