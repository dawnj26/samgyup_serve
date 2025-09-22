part of 'menu_details_bloc.dart';

@freezed
abstract class MenuDetailsState with _$MenuDetailsState {
  const factory MenuDetailsState.initial({
    required MenuItem menuItem,
    @Default([]) List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsInitial;

  const factory MenuDetailsState.loading({
    required MenuItem menuItem,
    @Default([]) List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsLoading;

  const factory MenuDetailsState.updating({
    required MenuItem menuItem,
    @Default([]) List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsUpdating;

  const factory MenuDetailsState.updated({
    required MenuItem menuItem,
    @Default([]) List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsUpdated;

  const factory MenuDetailsState.loaded({
    required MenuItem menuItem,
    required List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsLoaded;

  const factory MenuDetailsState.error({
    required String message,
    required MenuItem menuItem,
    @Default([]) List<Ingredient> ingredients,
    @Default({}) Map<String, InventoryItem> inventoryItems,
    @Default(false) bool isDirty,
  }) = MenuDetailsError;
}
