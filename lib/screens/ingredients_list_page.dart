import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/services/ingredients_list.dart';

IngredientsList ingredientsList = IngredientsList();
class IngredientsListPage extends StatefulWidget{
  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
  }

class _IngredientsListPageState extends State<IngredientsListPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(22),
        itemCount: ingredientsList.hardCodedIngredientList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('${ingredientsList.hardCodedIngredientList[index]}'),
            ElevatedButton(
                onPressed: () {
                  ingredientsList.chosenIngredients.add(
                      '${ingredientsList.hardCodedIngredientList[index]}');
                  print(ingredientsList.chosenIngredients);
                },
                child: const Text('Add')
            )
              ]
            ),
          );
        }
      ),
    );

  }
}
