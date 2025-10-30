part of 'inventory_details_bloc.dart';

@freezed
class InventoryDetailsEvent with _$InventoryDetailsEvent {
  const factory InventoryDetailsEvent.started() = _Started;
  const factory InventoryDetailsEvent.batchRefreshed() = _BatchRefreshed;
  const factory InventoryDetailsEvent.synced() = _Synced;
}
