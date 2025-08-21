part of 'inventory_edit_bloc.dart';

@freezed
abstract class InventoryEditState with _$InventoryEditState {
  const factory InventoryEditState.initial({
    required Expiration expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
  }) = InventoryEditInitial;

  const factory InventoryEditState.dirty({
    required Expiration expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
  }) = InventoryEditDirty;

  const factory InventoryEditState.loading({
    required Expiration expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
  }) = InventoryEditLoading;

  const factory InventoryEditState.success({
    @Default(Expiration.pure()) Expiration expiration,
    @Default(MeasurementUnit.pure()) MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
  }) = InventoryEditSuccess;

  const factory InventoryEditState.failure({
    required Expiration expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required String message,
  }) = InventoryEditFailure;
}
