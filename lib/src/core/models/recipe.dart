import 'package:cloud_firestore/cloud_firestore.dart';

enum ComfortLevel { safe, slightly_adventurous, adventurous }

class Recipe {
  final String id;
  final String name;
  final String cuisine;
  final String imageUrl;
  final int cookTimeMinutes;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final bool isFavorite;
  final ComfortLevel comfortLevel;

  Recipe({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.imageUrl,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    required this.comfortLevel,
    this.isFavorite = false,
  });

  factory Recipe.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Recipe(
      id: documentId,
      name: data['name'] ?? '',
      cuisine: data['cuisine'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      cookTimeMinutes: data['cookTimeMinutes'] ?? 0,
      difficulty: data['difficulty'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
      comfortLevel: ComfortLevel.values.firstWhere(
        (e) => e.toString().split('.').last == data['comfortLevel'],
        orElse: () => ComfortLevel.safe,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'cuisine': cuisine,
      'imageUrl': imageUrl,
      'cookTimeMinutes': cookTimeMinutes,
      'difficulty': difficulty,
      'ingredients': ingredients,
      'steps': steps,
      'isFavorite': isFavorite,
      'comfortLevel': comfortLevel.toString().split('.').last,
    };
  }
}
