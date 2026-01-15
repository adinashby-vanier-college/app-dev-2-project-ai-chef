import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_ai_app/screens/cooking_tools_screen.dart';

class DietaryRestrictionsScreen extends StatefulWidget {
  const DietaryRestrictionsScreen({super.key});

  @override
  _DietaryRestrictionsScreenState createState() =>
      _DietaryRestrictionsScreenState();
}

class _DietaryRestrictionsScreenState extends State<DietaryRestrictionsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _chosenRestrictions = [];
  final List<String> _availableRestrictions = ['dairy', 'peanut', 'vegan', 'vegetarian'];
  bool _isNextButtonLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRestrictions();
  }

  // Load restrictions from Firestore
  Future<void> _loadRestrictions() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dietaryRestrictions')
          .get();

      setState(() {
        _chosenRestrictions = snapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      print("Error loading dietary restrictions: $e");
    }
  }

  // Add restriction
  Future<void> _addRestriction(String restriction) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dietaryRestrictions')
          .add({'name': restriction, 'addedAt': FieldValue.serverTimestamp()});

      setState(() => _chosenRestrictions.add(restriction));
    } catch (e) {
      print("Error adding restriction: $e");
    }
  }

  // Remove restriction
  Future<void> _removeRestriction(String restriction) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dietaryRestrictions')
          .where('name', isEqualTo: restriction)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() => _chosenRestrictions.remove(restriction));
    } catch (e) {
      print("Error removing restriction: $e");
    }
  }

  void _toggleRestriction(String restriction) {
    if (_chosenRestrictions.contains(restriction)) {
      _removeRestriction(restriction);
    } else {
      _addRestriction(restriction);
    }
  }

  void _navigateToCookingToolsScreen() async {
    setState(() => _isNextButtonLoading = true);

    // Small delay to ensure Firestore writes complete
    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CookingToolsScreen()),
    );

    setState(() => _isNextButtonLoading = false);
  }

  Widget _buildRestrictionButton(String restriction, String imagePath) {
    final isSelected = _chosenRestrictions.contains(restriction);

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
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.5),
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
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: _availableRestrictions.length,
          itemBuilder: (context, index) {
            final restriction = _availableRestrictions[index];
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isNextButtonLoading ? null : _navigateToCookingToolsScreen,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isNextButtonLoading
                ? const CircularProgressIndicator(color: Colors.white)
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
