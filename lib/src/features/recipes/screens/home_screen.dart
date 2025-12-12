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

  // Allergy keyword map for more reliable filtering.
  static const Map<String, List<String>> allergyKeywordMap = {
    'peanuts': ['peanut', 'peanuts', 'peanut butter', 'peanut sauce'],
    'dairy': ['dairy', 'milk', 'cheese', 'yogurt', 'butter', 'cream', 'lactose'],
    'gluten': ['gluten', 'wheat', 'barley', 'rye', 'bread', 'flour', 'semolina'],
    'shellfish': ['shellfish', 'shrimp', 'crab', 'lobster', 'oyster', 'clam', 'mussel'],
    'soy': ['soy', 'soybean', 'tofu', 'edamame', 'soy milk', 'soy sauce'],
    'tree nuts': ['nut', 'almond', 'walnut', 'pecan', 'cashew', 'pistachio', 'hazelnut'],
    'fish': ['fish', 'salmon', 'tuna', 'cod', 'anchovy', 'sardine'],
    'eggs': ['egg', 'eggs', 'mayonnaise'],
  };

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
              
              // Normalize preferences for reliable matching
              final likedCuisines = userProfile.likedFoods.map((f) => f.toLowerCase().trim()).toSet();
              final dislikedCuisines = userProfile.dislikedFoods.map((f) => f.toLowerCase().trim()).toSet();
              final userAllergies = userProfile.allergies.map((a) => a.toLowerCase().trim()).toList();

              // Create a comprehensive set of all allergy keywords to check against
              final Set<String> allAllergyKeywords = {};
              for (final allergy in userAllergies) {
                allAllergyKeywords.add(allergy); // Add the base allergy term
                if (allergyKeywordMap.containsKey(allergy)) {
                  allAllergyKeywords.addAll(allergyKeywordMap[allergy]!);
                }
              }

              final filteredRecipes = allRecipes.where((recipe) {
                final recipeCuisine = recipe.cuisine.toLowerCase().trim();

                // Cuisine filtering
                final isLiked = likedCuisines.contains(recipeCuisine);
                final isDisliked = dislikedCuisines.contains(recipeCuisine);

                // Allergy filtering: check if any ingredient contains any allergy keyword
                final hasAllergy = allAllergyKeywords.any((keyword) => 
                  recipe.ingredients.any((ingredient) => 
                    ingredient.toLowerCase().trim().contains(keyword)
                  )
                );

                return isLiked && !isDisliked && !hasAllergy;
              }).toList();

              if (filteredRecipes.isEmpty) {
                return const Center(
                  child: Text(
                    'No recipes match your preferences. Try adding more!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
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
