import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/dietary_restrictions_screen.dart';
import 'package:recipe_ai_app/screens/landing_page.dart';
import 'package:recipe_ai_app/services/ingredients_list.dart';

class IngredientsListPage extends StatefulWidget {
  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  final IngredientsList ingredientsList = IngredientsList();

  // 1. Initialize Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // 2. Load existing ingredients when the screen opens
    _loadSelectedIngredients();
  }

  Future<void> _loadSelectedIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['chosenIngredients'] != null) {
        // Convert the dynamic list from Firestore back to a List<String>
        List<String> savedIngredients = List<String>.from(doc.data()!['chosenIngredients']);

        setState(() {
          ingredientsList.chosenIngredients = savedIngredients;
        });
      }
    } catch (e) {
      debugPrint("Error loading ingredients: $e");
    }
  }

  // 3. Method to save the ingredients list to Firestore
  Future<void> _saveIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'chosenIngredients': ingredientsList.chosenIngredients,
      }, SetOptions(merge: true));

      debugPrint("Ingredients saved successfully!");
    } catch (e) {
      debugPrint("Error saving ingredients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Ingredients"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(22),
        itemCount: ingredientsList.hardCodedIngredientList.length,
        itemBuilder: (BuildContext context, int index) {
          final ingredient = ingredientsList.hardCodedIngredientList[index];
          // Check if ingredient is already selected to change UI if needed
          final isSelected = ingredientsList.chosenIngredients.contains(ingredient);

          return Container(
            height: 50,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(ingredient),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.green : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (!isSelected) {
                        ingredientsList.chosenIngredients.add(ingredient);
                      } else {
                        ingredientsList.chosenIngredients.remove(ingredient);
                      }
                    });
                    print(ingredientsList.chosenIngredients);
                  },
                  child: Text(isSelected ? 'Added' : 'Add'),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LandingPage()),
                ),
                child: const Text("Back"),
              ),
            ),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  // 4. Save to DB before navigating
                  await _saveIngredients();

                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DietaryRestrictionsScreen(),
                      ),
                    );
                  }
                },
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}