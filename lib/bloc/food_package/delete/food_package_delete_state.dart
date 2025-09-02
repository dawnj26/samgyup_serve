part of 'food_package_delete_bloc.dart';

@freezed
class FoodPackageDeleteState with _$FoodPackageDeleteState {
  const factory FoodPackageDeleteState.initial() = FoodPackageDeleteInitial;
  const factory FoodPackageDeleteState.deleting() = FoodPackageDeleteDeleting;
  const factory FoodPackageDeleteState.success() = FoodPackageDeleteSuccess;
  const factory FoodPackageDeleteState.failure({required String errorMessage}) =
      FoodPackageDeleteFailure;
}
