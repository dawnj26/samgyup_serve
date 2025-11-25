part of 'food_package_bloc.dart';

@freezed
abstract class FoodPackageState with _$FoodPackageState {
  const factory FoodPackageState.initial({
    @Default([]) List<FoodPackageItem> packages,
    @Default(false) bool hasReachedMax,
    int? totalPackages,
  }) = FoodPackageInitial;

  const factory FoodPackageState.loading({
    required List<FoodPackageItem> packages,
    required bool hasReachedMax,
    int? totalPackages,
  }) = FoodPackageLoading;

  const factory FoodPackageState.success({
    required List<FoodPackageItem> packages,
    required bool hasReachedMax,
    int? totalPackages,
  }) = FoodPackageSuccess;

  const factory FoodPackageState.failure({
    required String error,
    required List<FoodPackageItem> packages,
    required bool hasReachedMax,
    int? totalPackages,
  }) = FoodPackageFailure;
}
