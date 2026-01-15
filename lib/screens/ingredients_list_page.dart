import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dietary_restrictions_screen.dart';

class IngredientsListPage extends StatefulWidget {
  const IngredientsListPage({super.key});

  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
}

class _IngredientsListPageState extends State<IngredientsListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = true;

  // For UI toggles
  List<String> _chosenIngredients = [];
  final List<String> _hardCodedIngredientList = [
    'Tomato', 'Onion', 'Garlic', 'Potato', 'Carrot'
  ];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('ingredients')
          .get();

      setState(() {
        _chosenIngredients =
            snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching ingredients: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addIngredient(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('ingredients')
          .add({'name': name, 'addedAt': FieldValue.serverTimestamp()});

      setState(() => _chosenIngredients.add(name));
    } catch (e) {
      print("Error adding ingredient: $e");
    }
  }

  Future<void> _removeIngredient(String name) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('ingredients')
          .where('name', isEqualTo: name)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() => _chosenIngredients.remove(name));
    } catch (e) {
      print("Error removing ingredient: $e");
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
        itemCount: _hardCodedIngredientList.length,
        itemBuilder: (context, index) {
          final ingredient = _hardCodedIngredientList[index];
          final isAdded = _chosenIngredients.contains(ingredient);

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
                    if (isAdded) {
                      _removeIngredient(ingredient);
                    } else {
                      _addIngredient(ingredient);
                    }
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
