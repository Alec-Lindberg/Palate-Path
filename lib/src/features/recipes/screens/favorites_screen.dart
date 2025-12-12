import 'package:flutter/material.dart';
import 'package:palate_path/src/core/models/recipe.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:palate_path/src/features/recipes/widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Recipes')),
      body: StreamBuilder<List<Recipe>>(
        stream: firebaseService.getFavoriteRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data ?? [];

          if (recipes.isEmpty) {
            return const Center(
              child: Text('You have no favorite recipes yet.'),
            );
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return RecipeCard(recipe: recipe);
            },
          );
        },
      ),
    );
  }
}
