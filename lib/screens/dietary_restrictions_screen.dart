import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/time_selection_screen.dart';

import '../services/ingredients_list.dart';

class DietaryRestrictionsScreen extends StatefulWidget{
  @override
  _DietaryRestrictionsScreenState createState() => _DietaryRestrictionsScreenState();
  }

class _DietaryRestrictionsScreenState extends State<DietaryRestrictionsScreen>{
  final IngredientsList ingredientsList = IngredientsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 20.0,
          runSpacing: 20.0,
        children: <Widget>[
          TextButton(
              onPressed: ()  { ingredientsList.chosenDietRestrictions.add("dairy");
                print(ingredientsList.chosenDietRestrictions);
                print(ingredientsList.chosenIngredients);
              },
              child: Image.asset(
                  'images/dairy.PNG',
                height: 130,
              ),
          ),
          TextButton(
            onPressed: ()  { ingredientsList.chosenDietRestrictions.add("peanut");
            print(ingredientsList.chosenDietRestrictions);
            print(ingredientsList.chosenIngredients);
            },
            child: Image.asset(
              'images/peanut.PNG',
              height: 130,
            ),
          ),
          TextButton(
            onPressed: ()  { ingredientsList.chosenDietRestrictions.add("vegan");
            print(ingredientsList.chosenDietRestrictions);
            print(ingredientsList.chosenIngredients);
            },
            child: Image.asset(
              'images/vegan.PNG',
              height: 130,
            ),
          ),
          TextButton(
            onPressed: ()  { ingredientsList.chosenDietRestrictions.add("vegetarian");
            print(ingredientsList.chosenDietRestrictions);
            print(ingredientsList.chosenIngredients);
            },
            child: Image.asset(
              'images/vegetarian.PNG',
              height: 130,
            ),
          ),
        ],
      ),
      ),
      bottomNavigationBar: Container(
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => TimeSelectionScreen(),
              ),
            ),
            child: Text("Next")),
      ),
    );
  }
}

