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
  Duration selectedDuration = const Duration(minutes: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Cooking Time"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  setState(() {
                    selectedDuration = newDuration;
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Selected Time: ${selectedDuration.inHours.toString().padLeft(2, '0')}h "
                "${(selectedDuration.inMinutes % 60).toString().padLeft(2, '0')}m",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
              // Save selected time
              ingredientsList.availableCookingTime =
                  "${selectedDuration.inHours}h ${(selectedDuration.inMinutes % 60)}m";
              print("Selected Time: ${ingredientsList.availableCookingTime}");

              // Navigate to CookingToolsScreen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CookingToolsScreen(),
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
}
