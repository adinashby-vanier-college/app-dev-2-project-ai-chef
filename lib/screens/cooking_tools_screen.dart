import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart';
import '../services/ingredients_list.dart';

class CookingToolsScreen extends StatefulWidget {
  const CookingToolsScreen({super.key});

  @override
  _CookingToolsScreenState createState() => _CookingToolsScreenState();
}

class _CookingToolsScreenState extends State<CookingToolsScreen> {
  final IngredientsList ingredientsList = IngredientsList();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCookingTools();
  }

  // Load previously selected tools from Firestore
  Future<void> _loadCookingTools() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          ingredientsList.chosenCookingTools =
              List<String>.from(data['chosenCookingTools'] ?? []);
        });
      }
    } catch (e) {
      print("Error loading cooking tools: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // Save tools to Firestore
  Future<void> _saveCookingTools() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'chosenCookingTools': ingredientsList.chosenCookingTools,
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error saving cooking tools: $e");
    }
  }

  // Toggle tool selection
  void _toggleTool(String tool) {
    setState(() {
      if (ingredientsList.chosenCookingTools.contains(tool)) {
        ingredientsList.chosenCookingTools.remove(tool);
      } else {
        ingredientsList.chosenCookingTools.add(tool);
      }
    });

    _saveCookingTools(); // save immediately
    print("Chosen tools: ${ingredientsList.chosenCookingTools}");
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tools = {
      "Oven Top": 'assets/images/oventop.PNG',
      "Camp Fire": 'assets/images/fire.PNG',
      "Microwave": 'assets/images/microwave.PNG',
      "Oven": 'assets/images/oven.PNG',
    };

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
          children: tools.entries
              .map((e) => _buildToolButton(e.key, e.value))
              .toList(),
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
              _saveCookingTools(); // make sure latest selection is saved
              Navigator.of(context).pushReplacement(
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
            imagePath,
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
