part of 'inventory_create_bloc.dart';

@freezed
abstract class InventoryCreateState with _$InventoryCreateState {
  const factory InventoryCreateState.initial({
    DateTime? expiration,
    @Default(MeasurementUnit.pure()) MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
  }) = InventoryCreateInitial;

  const factory InventoryCreateState.dirty({
    required DateTime? expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
  }) = InventoryCreateDirty;

  const factory InventoryCreateState.loading({
    required DateTime? expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
  }) = InventoryCreateLoading;

  const factory InventoryCreateState.success({
    DateTime? expiration,
    @Default(MeasurementUnit.pure()) MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
  }) = InventoryCreateSuccess;

  const factory InventoryCreateState.failure({
    required DateTime? expiration,
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required Stock stock,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required String message,
  }) = InventoryCreateFailure;
}
