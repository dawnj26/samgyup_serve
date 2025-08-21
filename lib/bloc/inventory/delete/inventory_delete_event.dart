part of 'inventory_delete_bloc.dart';

@freezed
abstract class InventoryDeleteEvent with _$InventoryDeleteEvent {
  const factory InventoryDeleteEvent.started({
    required InventoryItem item,
  }) = _Started;
}
