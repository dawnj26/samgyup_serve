part of 'ingredient_edit_bloc.dart';

@freezed
abstract class IngredientEditEvent with _$IngredientEditEvent {
  const factory IngredientEditEvent.submitted({
    required List<Ingredient> ingredients,
    required String menuId,
  }) = _Submitted;
}
