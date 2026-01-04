part of 'inventory_category_bloc.dart';

@freezed
abstract class InventoryCategoryState with _$InventoryCategoryState {
  const factory InventoryCategoryState.initial({
    required String category,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    @Default([]) List<Subcategory> subcategories,
    @Default([]) List<Subcategory> selectedSubcategories,
    String? categoryId,
  }) = InventoryCategoryInitial;

  const factory InventoryCategoryState.loading({
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required String category,
    required List<Subcategory> subcategories,
    required List<Subcategory> selectedSubcategories,
    String? categoryId,
  }) = InventoryCategoryLoading;

  const factory InventoryCategoryState.loadingItems({
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required String category,
    required List<Subcategory> subcategories,
    required List<Subcategory> selectedSubcategories,
    String? categoryId,
  }) = InventoryCategoryLoadingItems;

  const factory InventoryCategoryState.loaded({
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required String category,
    required List<Subcategory> subcategories,
    required List<Subcategory> selectedSubcategories,
    String? categoryId,
  }) = InventoryCategoryLoaded;

  const factory InventoryCategoryState.error({
    required String message,
    required List<InventoryItem> items,
    required bool hasReachedMax,
    required String category,
    required List<Subcategory> subcategories,
    required List<Subcategory> selectedSubcategories,
    String? categoryId,
  }) = InventoryCategoryError;
}
