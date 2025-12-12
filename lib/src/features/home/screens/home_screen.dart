import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:palate_path/src/core/models/recipe.dart';
import 'package:palate_path/src/core/services/firebase_service.dart';

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
        title: const Text('Palate Path'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => context.go('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      body: StreamBuilder<List<Recipe>>(
        stream: _firebaseService.getRecipes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data ?? [];
          if (recipes.isEmpty) {
            return const Center(child: Text('No recipes found.'));
          }

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    recipe.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                  title: Text(recipe.name),
                  subtitle: Text(recipe.difficulty),
                  trailing: StreamBuilder<bool>(
                    stream: _firebaseService.isRecipeFavorited(recipe.id),
                    builder: (context, favSnap) {
                      final isFav = favSnap.data ?? false;
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (_firebaseService.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please sign in to favorite recipes'),
                              ),
                            );
                            return;
                          }
                          _firebaseService.toggleFavorite(recipe.id, !isFav);
                        },
                      );
                    },
                  ),
                  onTap: () => context.go('/home/${recipe.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

