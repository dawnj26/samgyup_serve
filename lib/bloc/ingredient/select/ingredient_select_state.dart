part of 'ingredient_select_bloc.dart';

@freezed
abstract class IngredientSelectState with _$IngredientSelectState {
  const factory IngredientSelectState.initial({
    required List<Ingredient> selectedIngredients,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
  }) = IngredientSelectInitial;

  const factory IngredientSelectState.loading({
    required List<Ingredient> selectedIngredients,
    required List<InventoryItem> items,
    required bool hasReachedMax,
  }) = IngredientSelectLoading;

  const factory IngredientSelectState.loaded({
    required List<Ingredient> selectedIngredients,
    required List<InventoryItem> items,
    required bool hasReachedMax,
  }) = IngredientSelectLoaded;

  const factory IngredientSelectState.failure({
    required List<Ingredient> selectedIngredients,
    required List<InventoryItem> items,
    required bool hasReachedMax,
    String? errorMessage,
  }) = IngredientSelectFailure;
}
