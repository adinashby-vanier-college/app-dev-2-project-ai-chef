import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isNextButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDietaryRestrictions();
  }

  // Load user's dietary restrictions from Firestore
  Future<void> _loadUserDietaryRestrictions() async {
    final user = _auth.currentUser;
    if (user == null) return; // If no user is logged in, do nothing

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          // Retrieve and set the user's chosen restrictions
          ingredientsList.chosenDietRestrictions = List<String>.from(
            data?['chosenDietRestrictions'] ?? [],
          );
        });
      }
    } catch (e) {
      print("Error loading dietary restrictions: $e");
    }
  }

  // Save dietary restrictions to Firestore
  Future<void> _saveDietaryRestrictions() async {
    final user = _auth.currentUser;
    if (user == null) return; // If no user is logged in, do nothing

    try {
      await _firestore.collection('users').doc(user.uid).set(
        {
          'chosenDietRestrictions': ingredientsList.chosenDietRestrictions,
        },
        SetOptions(merge: true), // Merge to keep existing data intact
      );
    } catch (e) {
      print("Error saving dietary restrictions: $e");
    }
  }

  // Toggle dietary restriction selection
  void _toggleRestriction(String restriction) {
    setState(() {
      if (ingredientsList.chosenDietRestrictions.contains(restriction)) {
        ingredientsList.chosenDietRestrictions.remove(restriction);
      } else {
        ingredientsList.chosenDietRestrictions.add(restriction);
      }
    });

    // Save to Firestore immediately after toggling
    _saveDietaryRestrictions();

    print("Chosen restrictions: ${ingredientsList.chosenDietRestrictions}");
  }

  // Navigate to next screen with a loading state for the button
  void _navigateToNextScreen() async {
    setState(() {
      _isNextButtonLoading = true;
    });

    // Simulate saving the data or additional processing
    await Future.delayed(const Duration(seconds: 1));

    // Navigate after the process is done
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimeSelectionScreen(),
      ),
    );
  }

  // Build a restriction button widget
  Widget _buildRestrictionButton(String restriction, String imagePath) {
    final isSelected = ingredientsList.chosenDietRestrictions.contains(restriction);

    return GestureDetector(
      onTap: () => _toggleRestriction(restriction),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.deepPurple.withOpacity(0.5) : Colors.transparent,
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath, // Image for the restriction
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
            const SizedBox(height: 8),
            Text(
              _getRestrictionLabel(restriction),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get restriction labels
  String _getRestrictionLabel(String restriction) {
    switch (restriction) {
      case 'dairy':
        return 'Dairy Free';
      case 'peanut':
        return 'Peanut Free';
      case 'vegan':
        return 'Vegan';
      case 'vegetarian':
        return 'Vegetarian';
      default:
        return '';
    }
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
        child: SingleChildScrollView(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final restrictions = ['dairy', 'peanut', 'vegan', 'vegetarian'];
              final restriction = restrictions[index];
              final imagePaths = {
                'dairy': 'assets/images/dairy.PNG',
                'peanut': 'assets/images/peanut.PNG',
                'vegan': 'assets/images/vegan.PNG',
                'vegetarian': 'assets/images/vegetarian.PNG'
              };

              return _buildRestrictionButton(restriction, imagePaths[restriction]!);
            },
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isNextButtonLoading ? null : _navigateToNextScreen,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isNextButtonLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Next",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
