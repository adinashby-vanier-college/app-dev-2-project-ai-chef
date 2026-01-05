import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/cooking_tools_screen.dart';

import '../services/ingredients_list.dart';

class TimeSelectionScreen extends StatefulWidget{
  @override
  _TimeSelectionScreenState createState() =>  _TimeSelectionScreenState();
  }

class _TimeSelectionScreenState extends State<TimeSelectionScreen>{
  final IngredientsList ingredientsList = IngredientsList();
  String selectedDuration = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Available Cooking Time"),
        ),
        body: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: Duration(minutes: 30),
          onTimerDurationChanged: (Duration newDuration) {
            selectedDuration = newDuration.toString();
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Back"),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ingredientsList.availableCookingTime = selectedDuration;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CookingToolsScreen(),
                      ),
                    );
                  },
                    child: Text("Next")
                ),
                ),
            ],
          ),
        )
    );
  }
}