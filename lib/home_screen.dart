import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_ai_app/screens/recipe_steps_screen.dart';
import 'package:recipe_ai_app/services/ingredients_list.dart';
import 'cubit/recipe_cubit.dart';
import 'cubit/recipe_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IngredientsList ingredientsList = IngredientsList();
  List <String> recipeArray = [];


  void _fetchRecipe() {
    context.read<RecipeCubit>().fetchRecipe(ingredientsList.getRecipe());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recipe Suggestions'),
        backgroundColor: Colors.purple.shade50,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchRecipe,
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Get Recipes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.purple.shade100,
                foregroundColor: Colors.purple.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                final state = context.read<RecipeCubit>().state;

                if (state is RecipeLoaded) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          RecipeStepsScreen(recipeSteps: state.steps),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please Generate Recipe First")),
                  );
                }
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Show Steps'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.purple.shade100,
                foregroundColor: Colors.purple.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildRecipeDisplay(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeDisplay() {
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: (context, state) {
        if (state is RecipeInitial) {
          return const Center(
            child: Text(
              'Enter your ingredients and press \'Get Recipes\' to start cooking!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        } else if (state is RecipeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RecipeLoaded) {
          return SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.recipe,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        } else if (state is RecipeError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }
        return Container();
      },
    );
  }
}