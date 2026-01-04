part of 'inventory_edit_bloc.dart';

@freezed
class InventoryEditEvent with _$InventoryEditEvent {
  const factory InventoryEditEvent.saved() = _Saved;
  const factory InventoryEditEvent.started() = _Started;

  const factory InventoryEditEvent.nameChanged({
    required String name,
  }) = _NameChanged;
  const factory InventoryEditEvent.descriptionChanged({
    required String description,
  }) = _DescriptionChanged;
  const factory InventoryEditEvent.categoryChanged({
    required String category,
  }) = _CategoryChanged;
  const factory InventoryEditEvent.subcategoryChanged({
    required Subcategory? subcategory,
  }) = _SubcategoryChanged;
  const factory InventoryEditEvent.lowStockThresholdChanged({
    required String lowStockThreshold,
  }) = _LowStockThresholdChanged;
  const factory InventoryEditEvent.unitChanged({
    required MeasurementUnit measurementUnit,
  }) = _MeasurementUnitChanged;
  const factory InventoryEditEvent.priceChanged({
    required String price,
  }) = _PriceChanged;
  const factory InventoryEditEvent.imageChanged({
    required PlatformFile? imageFile,
  }) = _ImageChanged;
  const factory InventoryEditEvent.perHeadChanged({
    required String perHead,
  }) = _PerHeadChanged;
}
