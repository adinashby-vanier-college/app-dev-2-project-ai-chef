import 'package:flutter/material.dart';
import 'package:recipe_ai_app/home_screen.dart';
import '../services/ingredients_list.dart';

class CookingToolsScreen extends StatefulWidget {
  const CookingToolsScreen({super.key});

  @override
  _CookingToolsScreenState createState() => _CookingToolsScreenState();
}

class _CookingToolsScreenState extends State<CookingToolsScreen> {
  final IngredientsList ingredientsList = IngredientsList();

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
            _buildToolButton("oventop", 'images/oventop.PNG'),
            _buildToolButton("camp fire", 'images/fire.PNG'),
            _buildToolButton("microwave", 'images/microwave.PNG'),
            _buildToolButton("oven", 'images/oven.PNG'),
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
              // Navigate to HomeScreen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
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
        child: Image.asset(
          imagePath,
          height: 130,
        ),
      ),
    );
  }
}
