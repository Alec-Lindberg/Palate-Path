import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/core/models/recipe.dart';
import 'package:palate_path/src/core/models/user_profile.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:palate_path/src/features/recipes/widgets/recipe_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Discovery'),
      ),
      body: StreamBuilder<UserProfile?>(
        stream: _firebaseService.getUserProfile(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return Center(
              child: Text('Error loading profile: ${userSnapshot.error}'),
            );
          }

          final userProfile = userSnapshot.data;

          if (userProfile == null || userProfile.likedFoods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Set your food preferences to discover new recipes!',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/food-preferences'),
                    child: const Text('Set Preferences'),
                  ),
                ],
              ),
            );
          }

          return StreamBuilder<List<Recipe>>(
            stream: _firebaseService.getRecipes(),
            builder: (context, recipeSnapshot) {
              if (recipeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (recipeSnapshot.hasError) {
                return Center(
                  child: Text('Error loading recipes: ${recipeSnapshot.error}'),
                );
              }

              final allRecipes = recipeSnapshot.data ?? [];
              final likedCuisines = userProfile.likedFoods.map((f) => f.toLowerCase().trim()).toList();
              final dislikedCuisines = userProfile.dislikedFoods.map((f) => f.toLowerCase().trim()).toList();
              final allergies = userProfile.allergies.map((a) => a.toLowerCase().trim()).toList();

              final filteredRecipes = allRecipes.where((recipe) {
                final recipeCuisine = recipe.cuisine.toLowerCase().trim();

                final isLiked = likedCuisines.contains(recipeCuisine);
                final isDisliked = dislikedCuisines.contains(recipeCuisine);

                final hasAllergy = allergies.any((allergy) => 
                  recipe.ingredients.any((ingredient) => 
                    ingredient.toLowerCase().contains(allergy)
                  )
                );

                return isLiked && !isDisliked && !hasAllergy;
              }).toList();

              if (filteredRecipes.isEmpty) {
                return const Center(
                  child: Text(
                    'No recipes match your preferences. Try adding more!',
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return RecipeCard(recipe: recipe);
                },
              );
            },
          );
        },
      ),
    );
  }
}
