import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_ai_app/cubit/recipe_cubit.dart';
import 'package:recipe_ai_app/cubit/recipe_state.dart';
import '../services/ingredients_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final IngredientsList ingredientsList = IngredientsList();

  @override
  void initState() {
    super.initState();
    // Automatically fetch recipe when screen loads
    final ingredientsString = ingredientsList.getRecipe();
    context.read<RecipeCubit>().fetchRecipe(ingredientsString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recipe Suggestions'),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<RecipeCubit, RecipeState>(
          builder: (context, state) {
            if (state is RecipeInitial || state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RecipeLoaded) {
              return SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
