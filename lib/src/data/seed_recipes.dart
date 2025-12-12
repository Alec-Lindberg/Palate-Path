import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:palate_path/src/core/models/recipe.dart';

class SeedService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedRecipes({bool overwrite = false}) async {
    final recipesCollection = _firestore.collection('recipes');

    if (!overwrite) {
      final snapshot = await recipesCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        print('Recipes collection already seeded. Use overwrite: true to force reseed.');
        return;
      }
    }

    print('Seeding recipes (overwrite: $overwrite)... ');
    for (final recipe in _sampleRecipes) {
      await recipesCollection
          .doc(recipe.id)
          .set(recipe.toFirestore(), SetOptions(merge: true));
    }
    print('Finished seeding recipes.');
  }
}

final List<Recipe> _sampleRecipes = [
  Recipe(
    id: 'spaghetti-carbonara',
    name: 'Spaghetti Carbonara',
    cuisine: 'Italian',
    ingredients: [
      'Spaghetti',
      'Eggs',
      'Pancetta',
      'Parmesan Cheese',
      'Black Pepper',
    ],
    steps: [
      'Boil spaghetti.',
      'Fry pancetta.',
      'Mix eggs and cheese.',
      'Combine everything.',
    ],
    cookTimeMinutes: 20,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/spaghetti-carbonara/800/600',
  ),
  Recipe(
    id: 'beef-tacos',
    name: 'Beef Tacos',
    cuisine: 'Mexican',
    ingredients: ['Ground Beef', 'Taco Shells', 'Lettuce', 'Tomato', 'Cheese'],
    steps: [
      'Cook beef.',
      'Warm shells.',
      'Assemble tacos with toppings.',
    ],
    cookTimeMinutes: 25,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/beef-tacos/800/600',
  ),
  Recipe(
    id: 'sweet-and-sour-pork',
    name: 'Sweet and Sour Pork',
    cuisine: 'Chinese',
    ingredients: ['Pork', 'Pineapple', 'Bell Peppers', 'Soy Sauce', 'Vinegar'],
    steps: [
      'Stir-fry pork.',
      'Add vegetables and sauce.',
      'Simmer until thick.',
    ],
    cookTimeMinutes: 40,
    difficulty: 'Medium',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/sweet-and-sour-pork/800/600',
  ),
  Recipe(
    id: 'chicken-tikka-masala',
    name: 'Chicken Tikka Masala',
    cuisine: 'Indian',
    ingredients: [
      'Chicken',
      'Tomato Puree',
      'Cream',
      'Butter',
      'Garam Masala',
    ],
    steps: [
      'Marinate chicken.',
      'Cook in tomato gravy.',
      'Add cream and butter.',
    ],
    cookTimeMinutes: 45,
    difficulty: 'Medium',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/chicken-tikka-masala/800/600',
  ),
  Recipe(
    id: 'sushi-rolls',
    name: 'Sushi Rolls',
    cuisine: 'Japanese',
    ingredients: ['Sushi Rice', 'Nori', 'Fish', 'Cucumber', 'Avocado'],
    steps: ['Prepare rice.', 'Lay out nori and fillings.', 'Roll and slice.'],
    cookTimeMinutes: 60,
    difficulty: 'Hard',
    comfortLevel: ComfortLevel.adventurous,
    imageUrl:'https://picsum.photos/seed/sushi-rolls/800/600',
  ),
  Recipe(
    id: 'pad-thai',
    name: 'Pad Thai',
    cuisine: 'Thai',
    ingredients: [
      'Rice Noodles',
      'Shrimp',
      'Tofu',
      'Peanuts',
      'Bean Sprouts',
      'Lime',
    ],
    steps: [
      'Soak noodles.',
      'Stir-fry shrimp and tofu.',
      'Add noodles and sauce.',
      'Garnish with peanuts and sprouts.',
    ],
    cookTimeMinutes: 30,
    difficulty: 'Medium',
    comfortLevel: ComfortLevel.slightly_adventurous,
    imageUrl:'https://picsum.photos/seed/pad-thai/800/600',
  ),
  Recipe(
    id: 'pho-bo',
    name: 'Pho Bo',
    cuisine: 'Vietnamese',
    ingredients: [
      'Beef Bones',
      'Rice Noodles',
      'Beef Slices',
      'Onion',
      'Ginger',
      'Star Anise',
    ],
    steps: [
      'Simmer broth for hours.',
      'Cook noodles.',
      'Assemble bowl with beef, noodles, and broth.',
    ],
    cookTimeMinutes: 240,
    difficulty: 'Hard',
    comfortLevel: ComfortLevel.adventurous,
    imageUrl:'https://picsum.photos/seed/pho-bo/800/600',
  ),
  Recipe(
    id: 'kimchi-jjigae',
    name: 'Kimchi Jjigae',
    cuisine: 'Korean',
    ingredients: ['Kimchi', 'Pork Belly', 'Tofu', 'Gochujang', 'Scallions'],
    steps: [
      'Sauté pork and kimchi.',
      'Add water and gochujang.',
      'Simmer and add tofu.',
    ],
    cookTimeMinutes: 35,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.slightly_adventurous,
    imageUrl:'https://picsum.photos/seed/kimchi-jjigae/800/600',
  ),
  Recipe(
    id: 'greek-salad',
    name: 'Greek Salad',
    cuisine: 'Mediterranean',
    ingredients: [
      'Cucumber',
      'Tomatoes',
      'Feta Cheese',
      'Olives',
      'Red Onion',
      'Olive Oil',
    ],
    steps: [
      'Chop vegetables.',
      'Combine all ingredients.',
      'Drizzle with olive oil.',
    ],
    cookTimeMinutes: 15,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/greek-salad/800/600',
  ),
  Recipe(
    id: 'margherita-pizza',
    name: 'Margherita Pizza',
    cuisine: 'Italian',
    ingredients: [
      'Pizza Dough',
      'Tomatoes',
      'Fresh Mozzarella',
      'Basil',
      'Olive Oil',
    ],
    steps: ['Roll out dough.', 'Top with ingredients.', 'Bake until golden.'],
    cookTimeMinutes: 25,
    difficulty: 'Medium',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/margherita-pizza/800/600',
  ),
  Recipe(
    id: 'chicken-satay',
    name: 'Chicken Satay',
    cuisine: 'Thai',
    ingredients: [
      'Chicken Thighs',
      'Coconut Milk',
      'Peanut Butter',
      'Soy Sauce',
      'Curry Powder',
    ],
    steps: [
      'Marinate chicken skewers.',
      'Grill until cooked.',
      'Prepare peanut sauce.',
      'Serve together.',
    ],
    cookTimeMinutes: 35,
    difficulty: 'Medium',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/chicken-satay/800/600',
  ),
  Recipe(
    id: 'miso-soup',
    name: 'Miso Soup',
    cuisine: 'Japanese',
    ingredients: [
      'Dashi Broth',
      'Miso Paste',
      'Tofu',
      'Wakame Seaweed',
      'Scallions',
    ],
    steps: [
      'Bring dashi to a simmer.',
      'Dissolve miso paste.',
      'Add tofu and seaweed.',
      'Garnish with scallions.',
    ],
    cookTimeMinutes: 10,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/miso-soup/800/600',
  ),
  Recipe(
    id: 'banh-mi-sandwich',
    name: 'Banh Mi Sandwich',
    cuisine: 'Vietnamese',
    ingredients: [
      'Baguette',
      'Grilled Pork',
      'Pickled Carrots',
      'Daikon',
      'Cilantro',
      'Mayonnaise',
    ],
    steps: [
      'Toast baguette.',
      'Layer with pork and pickled vegetables.',
      'Add cilantro and mayonnaise.',
    ],
    cookTimeMinutes: 20,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.slightly_adventurous,
    imageUrl:'https://picsum.photos/seed/banh-mi-sandwich/800/600',
  ),
  Recipe(
    id: 'vegetable-stir-fry',
    name: 'Vegetable Stir Fry',
    cuisine: 'Chinese',
    ingredients: [
      'Broccoli',
      'Carrots',
      'Bell Peppers',
      'Soy Sauce',
      'Sesame Oil',
      'Rice',
    ],
    steps: [
      'Chop all the vegetables.',
      'Stir-fry the vegetables in a wok or large pan.',
      'Add the soy sauce and sesame oil.',
      'Serve over rice.',
    ],
    cookTimeMinutes: 20,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/vegetable-stir-fry/800/600',
  ),
  Recipe(
    id: 'chocolate-chip-cookies',
    name: 'Chocolate Chip Cookies',
    cuisine: 'American',
    ingredients: [
      'Flour',
      'Butter',
      'Sugar',
      'Brown Sugar',
      'Eggs',
      'Vanilla Extract',
      'Chocolate Chips',
    ],
    steps: [
      'Cream the butter and sugars together.',
      'Beat in the eggs and vanilla.',
      'Stir in the dry ingredients.',
      'Fold in the chocolate chips.',
      'Bake until golden brown.',
    ],
    cookTimeMinutes: 30,
    difficulty: 'Easy',
    comfortLevel: ComfortLevel.safe,
    imageUrl:'https://picsum.photos/seed/chocolate-chip-cookies/800/600',
  ),
];
