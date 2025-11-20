part of 'food_package_inventory_bloc.dart';

@freezed
class FoodPackageInventoryState with _$FoodPackageInventoryState {
  const factory FoodPackageInventoryState.initial() =
      FoodPackageInventoryInitial;
  const factory FoodPackageInventoryState.loading() =
      FoodPackageInventoryLoading;
  const factory FoodPackageInventoryState.success() =
      FoodPackageInventorySuccess;
  const factory FoodPackageInventoryState.failure({String? errorMessage}) =
      FoodPackageInventoryFailure;
}
