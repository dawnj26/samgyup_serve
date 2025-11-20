part of 'inventory_list_bloc.dart';

@freezed
class InventoryListEvent with _$InventoryListEvent {
  const factory InventoryListEvent.started() = _Started;
  const factory InventoryListEvent.reload() = _Reload;
  const factory InventoryListEvent.loadMore() = _LoadMore;
  const factory InventoryListEvent.itemRemoved({
    required InventoryItem item,
  }) = _ItemRemoved;
  const factory InventoryListEvent.itemChanged({
    required InventoryItem item,
  }) = _ItemChanged;
  const factory InventoryListEvent.categoriesChanged({
    required List<InventoryCategory> categories,
  }) = _CategoriesChanged;
}
