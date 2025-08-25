part of 'menu_create_bloc.dart';

@freezed
class MenuCreateEvent with _$MenuCreateEvent {
  const factory MenuCreateEvent.nameChanged(String name) = _NameChanged;
  const factory MenuCreateEvent.descriptionChanged(String description) =
      _DescriptionChanged;
  const factory MenuCreateEvent.priceChanged(String price) = _PriceChanged;
  const factory MenuCreateEvent.categoryChanged(MenuCategory? category) =
      _CategoryChanged;
  const factory MenuCreateEvent.ingredientsChanged(
    List<Ingredient> ingredients,
  ) = _IngredientsChanged;
  const factory MenuCreateEvent.submitted() = _Submitted;
}
