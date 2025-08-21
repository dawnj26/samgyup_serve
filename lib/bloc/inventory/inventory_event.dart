part of 'inventory_bloc.dart';

@freezed
class InventoryEvent with _$InventoryEvent {
  const factory InventoryEvent.started() = _Started;
  const factory InventoryEvent.reload() = _Reload;
}
