part of 'inventory_category_bloc.dart';

@freezed
abstract class InventoryCategoryState with _$InventoryCategoryState {
  const factory InventoryCategoryState.initial({
    required InventoryCategory category,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
  }) = InventoryCategoryInitial;

  const factory InventoryCategoryState.loading({
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required InventoryCategory category,
  }) = InventoryCategoryLoading;

  const factory InventoryCategoryState.loaded({
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required InventoryCategory category,
  }) = InventoryCategoryLoaded;

  const factory InventoryCategoryState.error({
    required String message,
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required InventoryCategory category,
  }) = InventoryCategoryError;
}
