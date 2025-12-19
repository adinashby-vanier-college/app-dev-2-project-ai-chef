import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart';
import '../services/ingredients_list.dart';

class DietaryRestrictionsScreen extends StatefulWidget {
  const DietaryRestrictionsScreen({super.key});

  @override
  _DietaryRestrictionsScreenState createState() =>
      _DietaryRestrictionsScreenState();
}

class _DietaryRestrictionsScreenState extends State<DietaryRestrictionsScreen> {
  final IngredientsList ingredientsList = IngredientsList();

  // Helper to toggle selection
  void _toggleRestriction(String restriction) {
    setState(() {
      if (ingredientsList.chosenDietRestrictions.contains(restriction)) {
        ingredientsList.chosenDietRestrictions.remove(restriction);
      } else {
        ingredientsList.chosenDietRestrictions.add(restriction);
      }
    });
    print("Chosen restrictions: ${ingredientsList.chosenDietRestrictions}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dietary Restrictions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: <Widget>[
            _buildRestrictionButton("dairy", 'images/dairy.PNG'),
            _buildRestrictionButton("peanut", 'images/peanut.PNG'),
            _buildRestrictionButton("vegan", 'images/vegan.PNG'),
            _buildRestrictionButton("vegetarian", 'images/vegetarian.PNG'),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Navigate to Time Selection
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TimeSelectionScreen(),
                ),
              );
            },
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRestrictionButton(String restriction, String imagePath) {
    final isSelected = ingredientsList.chosenDietRestrictions.contains(restriction);

    return GestureDetector(
      onTap: () => _toggleRestriction(restriction),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(
          imagePath,
          height: 130,
        ),
      ),
    );
  }
}
