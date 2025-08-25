part of 'ingredient_select_bloc.dart';

@freezed
class IngredientSelectEvent with _$IngredientSelectEvent {
  const factory IngredientSelectEvent.started() = _Started;
  const factory IngredientSelectEvent.loadMore() = _LoadMore;
  const factory IngredientSelectEvent.ingredientSelected(
    Ingredient ingredient,
  ) = _IngredientSelected;
  const factory IngredientSelectEvent.ingredientRemoved(
    Ingredient ingredient,
  ) = _IngredientRemoved;
}
