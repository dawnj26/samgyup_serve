part of 'ingredient_edit_bloc.dart';

@freezed
class IngredientEditState with _$IngredientEditState {
  const factory IngredientEditState.initial() = IngredientEditInitial;
  const factory IngredientEditState.saving() = IngredientEditSaving;
  const factory IngredientEditState.saved() = IngredientEditSaved;
  const factory IngredientEditState.error(String message) = IngredientEditError;
}
