part of 'inventory_edit_bloc.dart';

@freezed
abstract class InventoryEditState with _$InventoryEditState {
  const factory InventoryEditState.initial({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    DateTime? expiration,
  }) = InventoryEditInitial;

  const factory InventoryEditState.dirty({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    DateTime? expiration,
  }) = InventoryEditDirty;

  const factory InventoryEditState.loading({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    DateTime? expiration,
  }) = InventoryEditLoading;

  const factory InventoryEditState.success({
    required InventoryItem item,
    @Default(m.MeasurementUnit.pure()) m.MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    DateTime? expiration,
  }) = InventoryEditSuccess;

  const factory InventoryEditState.noChanges({
    DateTime? expiration,
    @Default(m.MeasurementUnit.pure()) m.MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
  }) = InventoryEditNoChanges;

  const factory InventoryEditState.failure({
    required m.MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required String message,
    DateTime? expiration,
  }) = InventoryEditFailure;
}
