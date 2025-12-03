


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/ingredients_list_page.dart';
import 'package:recipe_ai_app/services/ingredients_list.dart';

import '../home_screen.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
          child: TextButton(
              onPressed: () =>
              {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => IngredientsListPage(),
                  ),
                )
              },
              child: Text("Open App")
          )
      )
    );

  }
}