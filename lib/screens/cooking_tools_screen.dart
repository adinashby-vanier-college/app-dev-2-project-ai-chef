import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart'; // Import TimeSelectionScreen
import '../services/ingredients_list.dart';

class CookingToolsScreen extends StatefulWidget {
  const CookingToolsScreen({super.key});

  @override
  _CookingToolsScreenState createState() => _CookingToolsScreenState();
}

class _CookingToolsScreenState extends State<CookingToolsScreen> {
  final IngredientsList ingredientsList = IngredientsList();

  // Toggle tool selection
  void _toggleTool(String tool) {
    setState(() {
      if (ingredientsList.chosenCookingTools.contains(tool)) {
        ingredientsList.chosenCookingTools.remove(tool);
      } else {
        ingredientsList.chosenCookingTools.add(tool);
      }
    });
    print("Chosen tools: ${ingredientsList.chosenCookingTools}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Cooking Tools"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: <Widget>[
            _buildToolButton("Oven Top", 'assets/images/oventop.PNG'),
            _buildToolButton("Camp Fire", 'assets/images/fire.PNG'),
            _buildToolButton("Microwave", 'assets/images/microwave.PNG'),
            _buildToolButton("Oven", 'assets/images/oven.PNG'),
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
              // Navigate to TimeSelectionScreen after choosing tools
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const TimeSelectionScreen(), // Changed this to TimeSelectionScreen which is final screen where API call occurs
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

  // Build tool selection button widget
  Widget _buildToolButton(String tool, String imagePath) {
    final isSelected = ingredientsList.chosenCookingTools.contains(tool);

    return GestureDetector(
      onTap: () => _toggleTool(tool),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath, // Correct path
            height: 130,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                height: 130,
                width: 130,
                child: const Icon(Icons.error, color: Colors.red),
              );
            },
          ),
        ),
      ),
    );
  }
}
