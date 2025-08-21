part of 'inventory_delete_bloc.dart';

@freezed
abstract class InventoryDeleteState with _$InventoryDeleteState {
  const factory InventoryDeleteState.initial({
    required InventoryItem item,
  }) = InventoryDeleteInitial;
  const factory InventoryDeleteState.loading({
    required InventoryItem item,
  }) = InventoryDeleteLoading;
  const factory InventoryDeleteState.success({
    required InventoryItem item,
  }) = InventoryDeleteSuccess;
  const factory InventoryDeleteState.error({
    required String message,
    required InventoryItem item,
  }) = InventoryDeleteError;
}
