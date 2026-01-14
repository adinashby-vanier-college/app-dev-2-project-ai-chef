import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IngredientsList {
  static final IngredientsList _instance = IngredientsList._internal();

  factory IngredientsList() {
    return _instance;
  }

  IngredientsList._internal();

  // Default hardcoded ingredients
  List<String> hardCodedIngredientList = [
    "Acorn", "Agave", "Almonds", "Anchovies", "Anise", "Apple Cider Vinegar",
    "Apples", "Apricots", "Arugula", "Asparagus", "Avocado",
    "Bacon", "Baking Powder", "Baking Soda", "Bananas", "Barley",
    "Basil", "Bay Leaf", "Beans (Black)", "Beans (Kidney)", "Beef Broth",
    "Beets", "Bell Pepper (Red)", "Bell Pepper (Yellow)", "Black Olives",
    "Black Pepper", "Blueberries", "Bok Choy", "Brandy", "Bread Crumbs",
    "Broccoli", "Cabbage", "Cane Sugar", "Cantaloupe", "Caraway Seeds",
    "Carrots",
  ];

  List<String> chosenIngredients = [];
  List<String> chosenDietRestrictions = [];
  String availableCookingTime = "";
  List<String> chosenCookingTools = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch chosen ingredients (and other saved fields) for the current user
  Future<void> fetchChosenIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        // Safely get the lists or empty if not existing
        chosenIngredients =
            List<String>.from(data['chosenIngredients'] ?? []);
        chosenDietRestrictions =
            List<String>.from(data['chosenDietRestrictions'] ?? []);
        availableCookingTime = data['availableCookingTime'] ?? "";
        chosenCookingTools =
            List<String>.from(data['chosenCookingTools'] ?? []);
      }
    } catch (e) {
      print("Error fetching ingredients from Firebase: $e");
    }
  }

  /// Save chosen items for the current user
  Future<void> saveChosenIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'chosenIngredients': chosenIngredients,
        'chosenDietRestrictions': chosenDietRestrictions,
        'availableCookingTime': availableCookingTime,
        'chosenCookingTools': chosenCookingTools,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving ingredients to Firebase: $e");
    }
  }

  /// Build the recipe prompt to send to Gemini or any AI service
  String getRecipePrompt() {
    return "I have the following ingredients: ${chosenIngredients.join(', ')}. "
        "Avoid recipes that are: ${chosenDietRestrictions.join(', ')}. "
        "I have this amount of time: $availableCookingTime. "
        "Available cooking tools: ${chosenCookingTools.join(', ')}. "
        "You can add common kitchen ingredients if needed but do not add anything else. "
        "Give only the recipe.";
  }
}
