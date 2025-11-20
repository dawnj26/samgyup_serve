part of 'inventory_tab_bloc.dart';

enum MenuTabStatus {
  initial,
  loading,
  success,
  failure,
  refreshing,
  loadingItems,
}

@freezed
abstract class InventoryTabState with _$InventoryTabState {
  const factory InventoryTabState.initial({
    @Default(MenuTabStatus.initial) MenuTabStatus status,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    @Default([]) List<Subcategory> subcategories,
    @Default([]) List<Subcategory> selectedSubcategories,
    String? errorMessage,
  }) = _Initial;
}
