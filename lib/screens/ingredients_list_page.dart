import 'package:flutter/material.dart';
import 'dietary_restrictions_screen.dart';
import '../services/ingredients_list.dart';

class IngredientsListPage extends StatefulWidget {
  IngredientsListPage({super.key}); // NO const
  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  final IngredientsList ingredientsList = IngredientsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Ingredients"),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(22),
        itemCount: ingredientsList.hardCodedIngredientList.length,
        itemBuilder: (context, index) {
          final ingredient = ingredientsList.hardCodedIngredientList[index];
          final isAdded = ingredientsList.chosenIngredients.contains(ingredient);

          return Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ingredient,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (isAdded) {
                        ingredientsList.chosenIngredients.remove(ingredient);
                      } else {
                        ingredientsList.chosenIngredients.add(ingredient);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isAdded ? Colors.grey : Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(isAdded ? "Remove" : "Add"),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DietaryRestrictionsScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            "Next",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
