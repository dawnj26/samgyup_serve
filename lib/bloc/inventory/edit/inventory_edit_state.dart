part of 'inventory_edit_bloc.dart';

@freezed
abstract class InventoryEditState with _$InventoryEditState {
  const factory InventoryEditState.initial({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    File? imageFile,
  }) = InventoryEditInitial;

  const factory InventoryEditState.dirty({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    File? imageFile,
  }) = InventoryEditDirty;

  const factory InventoryEditState.loading({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    File? imageFile,
  }) = InventoryEditLoading;

  const factory InventoryEditState.success({
    required InventoryItem item,
    @Default(m.MeasurementUnit.pure()) m.MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    File? imageFile,
  }) = InventoryEditSuccess;

  const factory InventoryEditState.noChanges({
    @Default(m.MeasurementUnit.pure()) m.MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    File? imageFile,
  }) = InventoryEditNoChanges;

  const factory InventoryEditState.failure({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required String message,
    File? imageFile,
  }) = InventoryEditFailure;
}
