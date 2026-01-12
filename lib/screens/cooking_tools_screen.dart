import 'package:flutter/material.dart';
import 'package:recipe_ai_app/home_screen.dart';
import '../services/ingredients_list.dart';

class CookingToolsScreen extends StatefulWidget {
  @override
  _CookingToolsScreenState createState() => _CookingToolsScreenState();
}

class _CookingToolsScreenState extends State<CookingToolsScreen> {
  final IngredientsList ingredientsList = IngredientsList();

  final Set<String> _selectedTools = {};

  void _toggleTool(String toolId, String displayName) {
    setState(() {
      if (_selectedTools.contains(toolId)) {
        _selectedTools.remove(toolId);
        ingredientsList.chosenCookingTools.remove(displayName);
      } else {
        _selectedTools.add(toolId);
        ingredientsList.chosenCookingTools.add(displayName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Tools"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildToolCard("Stovetop", "images/oventop.PNG", "oventop"),
            _buildToolCard("Campfire", "images/fire.PNG", "fire"),
            _buildToolCard("Microwave", "images/microwave.PNG", "microwave"),
            _buildToolCard("Oven", "images/oven.PNG", "oven"),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: const Text("Generate Recipes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard(String label, String imagePath, String toolId) {
    bool isSelected = _selectedTools.contains(toolId);

    return GestureDetector(
      onTap: () => _toggleTool(toolId, label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 70),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange.shade800 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}