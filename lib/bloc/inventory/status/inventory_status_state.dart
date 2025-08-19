part of 'inventory_status_bloc.dart';

@freezed
abstract class InventoryStatusState with _$InventoryStatusState {
  const factory InventoryStatusState.initial({
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    InventoryItemStatus? status,
  }) = InventoryStatusInitial;

  const factory InventoryStatusState.loading({
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    InventoryItemStatus? status,
  }) = InventoryStatusLoading;

  const factory InventoryStatusState.loaded({
    required List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    InventoryItemStatus? status,
  }) = InventoryStatusLoaded;

  const factory InventoryStatusState.error({
    required String message,
    @Default([]) List<InventoryItem> items,
    @Default(false) bool hasReachedMax,
    InventoryItemStatus? status,
  }) = InventoryStatusError;
}
