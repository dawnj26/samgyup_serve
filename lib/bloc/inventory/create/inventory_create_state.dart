part of 'inventory_create_bloc.dart';

@freezed
abstract class InventoryCreateState with _$InventoryCreateState {
  const factory InventoryCreateState.initial({
    @Default(MeasurementUnit.pure()) MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    File? imageFile,
  }) = InventoryCreateInitial;

  const factory InventoryCreateState.dirty({
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    File? imageFile,
  }) = InventoryCreateDirty;

  const factory InventoryCreateState.loading({
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    File? imageFile,
  }) = InventoryCreateLoading;

  const factory InventoryCreateState.success({
    @Default(MeasurementUnit.pure()) MeasurementUnit measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    File? imageFile,
  }) = InventoryCreateSuccess;

  const factory InventoryCreateState.failure({
    required MeasurementUnit measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required String message,
    required Price price,
    File? imageFile,
  }) = InventoryCreateFailure;
}
