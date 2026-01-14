import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dietary_restrictions_screen.dart';
import '../services/ingredients_list.dart';

class IngredientsListPage extends StatefulWidget {
  IngredientsListPage({super.key});
  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  final IngredientsList ingredientsList = IngredientsList();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          ingredientsList.chosenIngredients =
              List<String>.from(data['chosenIngredients'] ?? []);
          ingredientsList.chosenDietRestrictions =
              List<String>.from(data['chosenDietRestrictions'] ?? []);
          ingredientsList.availableCookingTime =
              data['availableCookingTime'] ?? "";
          ingredientsList.chosenCookingTools =
              List<String>.from(data['chosenCookingTools'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching ingredients: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'chosenIngredients': ingredientsList.chosenIngredients,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving ingredients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Ingredients"),
        backgroundColor: Colors.deepPurple,
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
                    _saveIngredients(); // save immediately
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
            _saveIngredients(); // save before moving forward
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DietaryRestrictionsScreen(),
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
