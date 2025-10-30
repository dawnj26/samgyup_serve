part of 'inventory_bloc.dart';

@freezed
abstract class InventoryState with _$InventoryState {
  const factory InventoryState.initial({
    required InventoryInfo inventoryInfo,
  }) = InventoryInitial;
  const factory InventoryState.syncing({
    required InventoryInfo inventoryInfo,
  }) = InventorySyncing;
  const factory InventoryState.reloading({
    required InventoryInfo inventoryInfo,
  }) = InventoryReloading;
  const factory InventoryState.synced({
    required InventoryInfo inventoryInfo,
  }) = InventorySynced;
  const factory InventoryState.loaded({
    required InventoryInfo inventoryInfo,
  }) = InventoryLoaded;
  const factory InventoryState.error({
    required InventoryInfo inventoryInfo,
    required String message,
  }) = InventoryError;
}
