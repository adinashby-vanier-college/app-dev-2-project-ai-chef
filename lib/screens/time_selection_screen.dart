import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/ingredients_list.dart';
import '../services/gemini_service.dart';

class TimeSelectionScreen extends StatefulWidget {
  const TimeSelectionScreen({super.key});

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  final IngredientsList ingredientsList = IngredientsList();
  final GeminiService geminiService = GeminiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Duration selectedDuration = const Duration(minutes: 30);
  bool _isGeneratingRecipe = false;
  String? _generatedRecipe;

  @override
  void initState() {
    super.initState();
    _loadSelectedTime();
  }

  // Load previously selected cooking time from Firestore
  Future<void> _loadSelectedTime() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['availableCookingTime'] != null) {
        final timeStr = doc.data()!['availableCookingTime'] as String;
        ingredientsList.availableCookingTime = timeStr;

        // Convert "1h 30m" to Duration
        final hours = RegExp(r'(\d+)h').firstMatch(timeStr)?.group(1);
        final minutes = RegExp(r'(\d+)m').firstMatch(timeStr)?.group(1);

        setState(() {
          selectedDuration = Duration(
            hours: hours != null ? int.parse(hours) : 0,
            minutes: minutes != null ? int.parse(minutes) : 0,
          );
        });
      }
    } catch (e) {
      print("Error loading cooking time: $e");
    }
  }

  // Save selected cooking time to Firestore
  Future<void> _saveSelectedTime() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'availableCookingTime': ingredientsList.availableCookingTime,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving cooking time: $e");
    }
  }

  // Generate prompt for Gemini
  String _generateRecipePrompt() {
    String ingredients = ingredientsList.chosenIngredients.join(', ');
    String restrictions = ingredientsList.chosenDietRestrictions.join(', ');
    String time = ingredientsList.availableCookingTime;
    String tools = ingredientsList.chosenCookingTools.join(', ');

    return '''
I have the following ingredients: $ingredients.
Dietary restrictions: $restrictions.
I have $time to cook.
I have the following tools available: $tools.
Suggest a recipe based on these.
''';
  }

  // Call Gemini API to generate recipe
  Future<void> _generateRecipe() async {
    setState(() => _isGeneratingRecipe = true);

    try {
      final prompt = _generateRecipePrompt();
      final recipe = await geminiService.getRecipe(prompt);

      setState(() {
        _generatedRecipe = recipe;
        _isGeneratingRecipe = false;
      });
    } catch (e) {
      setState(() => _isGeneratingRecipe = false);
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
              ElevatedButton(
                onPressed: _isGeneratingRecipe
                    ? null
                    : () async {
                        // Save selected time locally
                        ingredientsList.availableCookingTime =
                            "${selectedDuration.inHours}h ${(selectedDuration.inMinutes % 60)}m";

                        // Save to Firestore
                        await _saveSelectedTime();

                        // Generate recipe
                        await _generateRecipe();
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
              if (_generatedRecipe != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _generatedRecipe!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
