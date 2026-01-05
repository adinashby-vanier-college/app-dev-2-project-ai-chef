import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/dietary_restrictions_screen.dart';
import 'package:recipe_ai_app/screens/landing_page.dart';
import 'package:recipe_ai_app/services/ingredients_list.dart';

class IngredientsListPage extends StatefulWidget{
  @override
  _IngredientsListPageState createState() => _IngredientsListPageState();
  }

class _IngredientsListPageState extends State<IngredientsListPage> {
  final IngredientsList ingredientsList = IngredientsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Ingredients"),
        ),
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
                                '${ingredientsList
                                    .hardCodedIngredientList[index]}');
                            print(ingredientsList.chosenIngredients);
                          },
                          child: const Text('Add')
                      )
                    ]
                ),
              );
            }
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LandingPage(),
                        ),
                      ),
                  child: Text("Back"),
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DietaryRestrictionsScreen(),
                        ),
                      ),
                  child: Text("Next"),
                ),
              ),
            ],
          ),
        )
    );
  }
}
