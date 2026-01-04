part of 'inventory_category_bloc.dart';

@freezed
class InventoryCategoryEvent with _$InventoryCategoryEvent {
  const factory InventoryCategoryEvent.started() = _Started;
  const factory InventoryCategoryEvent.reload() = _Reload;
  const factory InventoryCategoryEvent.loadMore() = _LoadMore;
  const factory InventoryCategoryEvent.itemRemoved({
    required InventoryItem item,
  }) = _ItemRemoved;
  const factory InventoryCategoryEvent.itemChanged({
    required InventoryItem item,
  }) = _ItemChanged;
  const factory InventoryCategoryEvent.subcategoryChanged({
    required List<Subcategory> subcategories,
  }) = _SubcategoryChanged;
  const factory InventoryCategoryEvent.categoryChanged({
    required String category,
  }) = _CategoryChanged;
}
