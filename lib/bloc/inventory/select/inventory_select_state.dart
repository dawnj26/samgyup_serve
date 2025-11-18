part of 'inventory_select_bloc.dart';

enum InventorySelectStatus { initial, finished }

@freezed
abstract class InventorySelectState with _$InventorySelectState {
  const factory InventorySelectState.initial({
    required List<InventoryItem> selectedItems,
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(InventorySelectStatus.initial) InventorySelectStatus status,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _Initial;
}
