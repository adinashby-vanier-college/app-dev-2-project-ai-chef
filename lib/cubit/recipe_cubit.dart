import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/gemini_service.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final GeminiService _geminiService;

  RecipeCubit(this._geminiService) : super(RecipeInitial());

  Future<void> fetchRecipe(String ingredients) async {
    if (ingredients.trim().isEmpty) {
      emit(const RecipeError("Please enter ingredients."));
      return;
    }

    emit(RecipeLoading());
    try {
      final result = await _geminiService.getRecipe(ingredients);

      if (result.toLowerCase().contains("error") || result.toLowerCase().contains("network")) {
        emit(RecipeError(result));
      } else {
        emit(RecipeLoaded(result));
      }
    } catch (e) {
      emit(RecipeError("An unexpected error occurred: ${e.toString()}"));
    }
  }
}
