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
    required InventoryCategory category,
  }) = _CategoryChanged;
  const factory InventoryCreateEvent.subcategoryChanged({
    required Subcategory? subcategory,
  }) = _SubcategoryChanged;
  const factory InventoryCreateEvent.lowStockThresholdChanged({
    required String lowStockThreshold,
  }) = _LowStockThresholdChanged;
  const factory InventoryCreateEvent.unitChanged({
    required MeasurementUnit measurementUnit,
  }) = _MeasurementUnitChanged;
  const factory InventoryCreateEvent.priceChanged({
    required String price,
  }) = _PriceChanged;
  const factory InventoryCreateEvent.imageChanged({
    required PlatformFile? imageFile,
  }) = _ImageChanged;
  const factory InventoryCreateEvent.perHeadChanged({
    required String perHead,
  }) = _PerHeadChanged;
}
