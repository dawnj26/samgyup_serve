part of 'food_package_details_bloc.dart';

@freezed
abstract class FoodPackageDetailsState with _$FoodPackageDetailsState {
  const factory FoodPackageDetailsState.initial({
    required FoodPackage package,
    @Default([]) List<MenuItem> menuItems,
    @Default(false) bool isDirty,
  }) = FoodPackageDetailsInitial;

  const factory FoodPackageDetailsState.loading({
    required FoodPackage package,
    required List<MenuItem> menuItems,
    required bool isDirty,
  }) = FoodPackageDetailsLoading;

  const factory FoodPackageDetailsState.success({
    required FoodPackage package,
    required List<MenuItem> menuItems,
    required bool isDirty,
  }) = FoodPackageDetailsSuccess;

  const factory FoodPackageDetailsState.failure({
    required FoodPackage package,
    required List<MenuItem> menuItems,
    required bool isDirty,
    String? errorMessage,
  }) = FoodPackageDetailsFailure;
}
