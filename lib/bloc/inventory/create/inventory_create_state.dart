part of 'inventory_create_bloc.dart';

@freezed
abstract class InventoryCreateState with _$InventoryCreateState {
  const factory InventoryCreateState.initial({
    @Default(MeasurementUnitInput.pure()) MeasurementUnitInput measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(<Subcategory>[]) List<Subcategory> subcategories,
    @Default(PerHead.pure()) PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateInitial;

  const factory InventoryCreateState.dirty({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required List<Subcategory> subcategories,
    required PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateDirty;

  const factory InventoryCreateState.loading({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required List<Subcategory> subcategories,
    required PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateLoading;

  const factory InventoryCreateState.success({
    @Default(MeasurementUnitInput.pure()) MeasurementUnitInput measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(<Subcategory>[]) List<Subcategory> subcategories,
    @Default(PerHead.pure()) PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateSuccess;

  const factory InventoryCreateState.failure({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required String message,
    required Price price,
    required List<Subcategory> subcategories,
    required PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateFailure;

  const factory InventoryCreateState.loadingSubcategories({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required List<Subcategory> subcategories,
    required PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateLoadingSubcategories;

  const factory InventoryCreateState.loadedSubcategories({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required List<Subcategory> subcategories,
    required PerHead perHead,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryCreateLoadedSubcategories;
}
