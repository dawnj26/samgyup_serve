part of 'food_package_details_bloc.dart';

@freezed
abstract class FoodPackageDetailsState with _$FoodPackageDetailsState {
  const factory FoodPackageDetailsState.initial({
    required FoodPackage package,
    @Default([]) List<MenuItem> menuItems,
  }) = FoodPackageDetailsInitial;

  const factory FoodPackageDetailsState.loading({
    required FoodPackage package,
    required List<MenuItem> menuItems,
  }) = FoodPackageDetailsLoading;

  const factory FoodPackageDetailsState.success({
    required FoodPackage package,
    required List<MenuItem> menuItems,
  }) = FoodPackageDetailsSuccess;

  const factory FoodPackageDetailsState.failure({
    required FoodPackage package,
    required List<MenuItem> menuItems,
    String? errorMessage,
  }) = FoodPackageDetailsFailure;
}
