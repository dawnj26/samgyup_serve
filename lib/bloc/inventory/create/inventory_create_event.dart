part of 'inventory_create_bloc.dart';

@freezed
class InventoryCreateEvent with _$InventoryCreateEvent {
  const factory InventoryCreateEvent.started() = _Started;
}
