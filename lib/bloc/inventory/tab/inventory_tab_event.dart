part of 'inventory_tab_bloc.dart';

@freezed
class InventoryTabEvent with _$InventoryTabEvent {
  const factory InventoryTabEvent.started() = _Started;
  const factory InventoryTabEvent.fetchMore() = _FetchMore;
  const factory InventoryTabEvent.refresh() = _Refresh;
  const factory InventoryTabEvent.subcategoriesChanged({
    required List<Subcategory> selectedSubcategories,
  }) = _SubcategoriesChanged;
}
