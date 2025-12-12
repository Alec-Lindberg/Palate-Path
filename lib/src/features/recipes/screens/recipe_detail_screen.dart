import 'package:flutter/material.dart';
import 'package:palate_path/src/core/models/recipe.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';
import 'package:palate_path/src/features/recipes/widgets/recipe_image.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
     body: StreamBuilder<Recipe?>(
  stream: firebaseService.getRecipe(recipeId),
builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
  }
  if (snapshot.hasError) {
    return Center(child: Text('Error: ${snapshot.error}'));
  }

  final recipe = snapshot.data;
  if (recipe == null) {
    return const Center(child: Text('Recipe not found.'));
  }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    recipe.name,
                    style: const TextStyle(shadows: [Shadow(blurRadius: 10.0)]),
                  ),
                  background: RecipeImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(context, Icons.kitchen, 'Cuisine',
                          recipe.cuisine),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, Icons.leaderboard, 'Difficulty',
                          recipe.difficulty),
                      const SizedBox(height: 12),
                      _buildInfoRow(context, Icons.timer, 'Cook Time',
                          '${recipe.cookTimeMinutes} minutes'),
                      const Divider(height: 32),
                      Text(
                        'Ingredients',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      for (var ingredient in recipe.ingredients)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text('• $ingredient'),
                        ),
                      const Divider(height: 32),
                      Text(
                        'Steps',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < recipe.steps.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${i + 1}'),
                            ),
                            title: Text(recipe.steps[i]),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
