part of 'inventory_edit_bloc.dart';

@freezed
abstract class InventoryEditState with _$InventoryEditState {
  const factory InventoryEditState.initial({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    @Default([]) List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditInitial;

  const factory InventoryEditState.initializing({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    @Default([]) List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditInitializing;

  const factory InventoryEditState.initialized({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    @Default([]) List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditInitialized;

  const factory InventoryEditState.dirty({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    required List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditDirty;

  const factory InventoryEditState.loading({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    required List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditLoading;

  const factory InventoryEditState.success({
    required InventoryItem item,
    @Default(MeasurementUnitInput.pure()) MeasurementUnitInput measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(PerHead.pure()) PerHead perHead,
    @Default([]) List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditSuccess;

  const factory InventoryEditState.noChanges({
    @Default(MeasurementUnitInput.pure()) MeasurementUnitInput measurementUnit,
    @Default(Category.pure()) Category category,
    @Default(Name.pure()) Name name,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(PerHead.pure()) PerHead perHead,
    @Default([]) List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditNoChanges;

  const factory InventoryEditState.failure({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required String message,
    required PerHead perHead,
    required List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditFailure;

  const factory InventoryEditState.loadingSubcategories({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    required List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditLoadingSubcategories;

  const factory InventoryEditState.loadedSubcategories({
    required MeasurementUnitInput measurementUnit,
    required Category category,
    required Name name,
    required LowStockThreshold lowStockThreshold,
    required Description description,
    required Price price,
    required PerHead perHead,
    required List<Subcategory> subcategories,
    Subcategory? subcategory,
    PlatformFile? imageFile,
  }) = InventoryEditLoadedSubcategories;
}
