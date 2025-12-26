import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_ai_app/services/recipe_steps.dart';
import '../services/gemini_service.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final GeminiService _geminiService;


  RecipeCubit(this._geminiService) : super(RecipeInitial());

  Future<void> fetchRecipe(String ingredients) async {
    if (ingredients.isEmpty) {
      emit(const RecipeError("Please enter ingredients."));
      return;
    }

    emit(RecipeLoading());
    try {
      String result = await _geminiService.getRecipe(ingredients);

      final recipeStepsObj  = RecipeSteps(result);
      List <String> stepsArray = recipeStepsObj.parseTextIntoSteps();

      if (result.startsWith("Error:")) {
        emit(RecipeError(result));
      } else {
        emit(RecipeLoaded(result, stepsArray));
      }
    } catch (e) {
      emit(RecipeError("An error occurred: ${e.toString()}"));
    }
  }
}