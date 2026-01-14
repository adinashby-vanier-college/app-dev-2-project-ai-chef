import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/cooking_tools_screen.dart'; // You can remove this if not needed anymore
import '../services/ingredients_list.dart';
import '../services/gemini_service.dart';

class TimeSelectionScreen extends StatefulWidget {
  const TimeSelectionScreen({super.key});

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  final IngredientsList ingredientsList = IngredientsList();
  final GeminiService geminiService = GeminiService(); // Your Gemini API service
  Duration selectedDuration = const Duration(minutes: 30);
  bool _isGeneratingRecipe = false;
  String? _generatedRecipe;

  // Function to generate the recipe prompt
  String _generateRecipePrompt() {
    String ingredients = ingredientsList.chosenIngredients.join(', ');
    String restrictions = ingredientsList.chosenDietRestrictions.join(', ');
    String time = ingredientsList.availableCookingTime;
    String tools = ingredientsList.chosenCookingTools.join(', ');

    // Construct the prompt
    return '''
      I have the following ingredients: $ingredients.
      Dietary restrictions: $restrictions.
      I have $time to cook.
      I have the following tools available: $tools.
      Suggest a recipe based on these.
    ''';
  }

  // Function to fetch the recipe from Gemini API
  Future<void> _generateRecipe() async {
    String prompt = _generateRecipePrompt();
    setState(() {
      _isGeneratingRecipe = true; // Show loading indicator
    });

    try {
      String recipe = await geminiService.getRecipe(prompt);
      setState(() {
        _isGeneratingRecipe = false; // Hide loading indicator
        _generatedRecipe = recipe;  // Store the generated recipe
      });
    } catch (e) {
      print("Error generating recipe: $e");
      setState(() {
        _isGeneratingRecipe = false; // Hide loading indicator
      });
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating recipe: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Cooking Time"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cupertino timer picker for selecting the cooking time
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  setState(() {
                    selectedDuration = newDuration;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Selected Time: ${selectedDuration.inHours.toString().padLeft(2, '0')}h "
                "${(selectedDuration.inMinutes % 60).toString().padLeft(2, '0')}m",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Button to generate recipe after selecting time
              ElevatedButton(
                onPressed: _isGeneratingRecipe
                    ? null // Disable the button while generating recipe
                    : () {
                        // Save selected time to ingredients list
                        ingredientsList.availableCookingTime =
                            "${selectedDuration.inHours}h ${(selectedDuration.inMinutes % 60)}m";
                        print("Selected Time: ${ingredientsList.availableCookingTime}");

                        // Generate the recipe
                        _generateRecipe();
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isGeneratingRecipe
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Generate Recipe",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 20),
              // Display the generated recipe if available
              if (_generatedRecipe != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _generatedRecipe!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
