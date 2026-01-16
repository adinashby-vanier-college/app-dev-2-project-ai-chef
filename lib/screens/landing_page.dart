
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_ai_app/screens/image_upload_screen.dart';
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
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              "images/recipe_step_1.png",
              fit: BoxFit.cover,
            ),  
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => IngredientsListPage(),
                      ),
                    );
                  },
                  child: Text("Choose Ingredients to Generate a Recipe"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ImageUploadScreen(),
                      ),
                    );
                  },
                  child: Text("Upload Image to Generate a Recipe"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}