import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/home_screen.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart';

import '../services/ingredients_list.dart';

class CookingToolsScreen extends StatefulWidget{
  @override
  _CookingToolsScreenState createState() =>  _CookingToolsScreenState();
}

class _CookingToolsScreenState extends State<CookingToolsScreen>{
  final IngredientsList ingredientsList = IngredientsList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Available Cooking Tools"),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
          children: <Widget>[
            TextButton(
              onPressed: ()  { ingredientsList.chosenCookingTools.add("oventop");
              print(ingredientsList.chosenDietRestrictions);
              print(ingredientsList.chosenIngredients);
              },
              child: Image.asset(
                'images/oventop.PNG',
                height: 130,
              ),
            ),
            TextButton(
              onPressed: ()  { ingredientsList.chosenCookingTools.add("camp fire");
              print(ingredientsList.chosenDietRestrictions);
              print(ingredientsList.chosenIngredients);
              },
              child: Image.asset(
                'images/fire.PNG',
                height: 130,
              ),
            ),
            TextButton(
              onPressed: ()  { ingredientsList.chosenCookingTools.add("microwave");
              print(ingredientsList.chosenDietRestrictions);
              print(ingredientsList.chosenIngredients);
              },
              child: Image.asset(
                'images/microwave.PNG',
                height: 130,
              ),
            ),
            TextButton(
              onPressed: ()  { ingredientsList.chosenCookingTools.add("oven");
              print(ingredientsList.chosenDietRestrictions);
              print(ingredientsList.chosenIngredients);
              },
              child: Image.asset(
                'images/oven.PNG',
                height: 130,
              ),
            ),
          ],
        ),
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

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
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