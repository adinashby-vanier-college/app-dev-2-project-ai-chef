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
        body: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: Duration(minutes: 30),
          onTimerDurationChanged: (Duration newDuration) {
            selectedDuration = newDuration.toString();
          },
        ),
        bottomNavigationBar: Container(
    child: ElevatedButton(
    onPressed: () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CookingToolsScreen(),
        ),
      );
      ingredientsList.availableCookingTime = selectedDuration;
      print(ingredientsList.availableCookingTime);

    },
    child: Text("Next")),
    ),
    );
  }
}