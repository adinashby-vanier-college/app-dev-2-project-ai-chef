import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart';
import '../services/ingredients_list.dart';

class DietaryRestrictionsScreen extends StatefulWidget {
  @override
  _DietaryRestrictionsScreenState createState() => _DietaryRestrictionsScreenState();
}

class _DietaryRestrictionsScreenState extends State<DietaryRestrictionsScreen> {
  final IngredientsList ingredientsList = IngredientsList();

  final Set<String> _selectedRestrictions = {};

  void _toggleRestriction(String name) {
    setState(() {
      if (_selectedRestrictions.contains(name)) {
        _selectedRestrictions.remove(name);
        ingredientsList.chosenDietRestrictions.remove(name);
      } else {
        _selectedRestrictions.add(name);
        ingredientsList.chosenDietRestrictions.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dietary Restrictions"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildRestrictionCard("Dairy Free", "images/dairy.PNG", "dairy"),
            _buildRestrictionCard("Nut Free", "images/peanut.PNG", "peanut"),
            _buildRestrictionCard("Vegan", "images/vegan.PNG", "vegan"),
            _buildRestrictionCard("Vegetarian", "images/vegetarian.PNG", "vegetarian"),
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
                      MaterialPageRoute(builder: (context) => TimeSelectionScreen()),
                    );
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestrictionCard(String label, String imagePath, String value) {
    bool isSelected = _selectedRestrictions.contains(value);

    return GestureDetector(
      onTap: () => _toggleRestriction(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
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
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green.shade700 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}