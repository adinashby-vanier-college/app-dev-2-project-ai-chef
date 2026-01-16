import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/cooking_tools_screen.dart';
import '../services/ingredients_list.dart';

class TimeSelectionScreen extends StatefulWidget {
  const TimeSelectionScreen({super.key});

  @override
  _TimeSelectionScreenState createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  final IngredientsList ingredientsList = IngredientsList();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // This duration controls the picker's visual position
  Duration _currentDuration = const Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    // Load existing data from Firestore when the screen opens
    _loadSelectedTime();
  }

  // Load previously selected cooking time from Firestore
  Future<void> _loadSelectedTime() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['availableCookingTime'] != null) {
        final timeStr = doc.data()!['availableCookingTime'] as String;

        // Update the singleton service
        ingredientsList.availableCookingTime = timeStr;

        // Parse "1h 30m" back into a Duration for the UI picker
        final hoursMatch = RegExp(r'(\d+)h').firstMatch(timeStr);
        final minutesMatch = RegExp(r'(\d+)m').firstMatch(timeStr);

        final h = int.tryParse(hoursMatch?.group(1) ?? '0') ?? 0;
        final m = int.tryParse(minutesMatch?.group(1) ?? '0') ?? 0;

        setState(() {
          _currentDuration = Duration(hours: h, minutes: m);
        });
      }
    } catch (e) {
      debugPrint("Error loading cooking time: $e");
    }
  }

  // Save selected cooking time to Firestore
  Future<void> _saveSelectedTime() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Use the value already stored in ingredientsList
      await _firestore.collection('users').doc(user.uid).set({
        'availableCookingTime': ingredientsList.availableCookingTime,
      }, SetOptions(merge: true));

      debugPrint("Successfully saved: ${ingredientsList.availableCookingTime}");
    } catch (e) {
      debugPrint("Error saving cooking time: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle actionButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.deepPurple.shade400,
      side: BorderSide(color: Colors.grey.shade200),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Cooking Time"), centerTitle: true),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.timer_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            "How much time do you have?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            height: 250,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              initialTimerDuration: _currentDuration,
              onTimerDurationChanged: (Duration newDuration) {
                setState(() {
                  _currentDuration = newDuration;
                });
              },
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: actionButtonStyle,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Back"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  style: actionButtonStyle,
                  onPressed: () async {
                    // 1. Update the local service string first
                    ingredientsList.availableCookingTime =
                    "${_currentDuration.inHours}h ${_currentDuration.inMinutes % 60}m";

                    // 2. Wait for the save to complete
                    await _saveSelectedTime();

                    // 3. Navigate
                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CookingToolsScreen()),
                      );
                    }
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
}