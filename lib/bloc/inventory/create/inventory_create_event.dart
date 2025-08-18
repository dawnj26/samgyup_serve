part of 'inventory_create_bloc.dart';

@freezed
class InventoryCreateEvent with _$InventoryCreateEvent {
  const factory InventoryCreateEvent.saved() = _Saved;

  const factory InventoryCreateEvent.nameChanged({
    required String name,
  }) = _NameChanged;
  const factory InventoryCreateEvent.descriptionChanged({
    required String description,
  }) = _DescriptionChanged;
  const factory InventoryCreateEvent.categoryChanged({
    required i.InventoryCategory category,
  }) = _CategoryChanged;
  const factory InventoryCreateEvent.stockChanged({
    required String stock,
  }) = _StockChanged;
  const factory InventoryCreateEvent.lowStockThresholdChanged({
    required String lowStockThreshold,
  }) = _LowStockThresholdChanged;
  const factory InventoryCreateEvent.unitChanged({
    required i.MeasurementUnit measurementUnit,
  }) = _MeasurementUnitChanged;
  const factory InventoryCreateEvent.expirationChanged({
    required DateTime? expiration,
  }) = _ExpirationChanged;
}
