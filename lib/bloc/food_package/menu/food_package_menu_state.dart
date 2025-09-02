part of 'food_package_menu_bloc.dart';

@freezed
class FoodPackageMenuState with _$FoodPackageMenuState {
  const factory FoodPackageMenuState.initial() = FoodPackageMenuInitial;
  const factory FoodPackageMenuState.loading() = FoodPackageMenuLoading;
  const factory FoodPackageMenuState.success() = FoodPackageMenuSuccess;
  const factory FoodPackageMenuState.failure({String? errorMessage}) =
      FoodPackageMenuFailure;
}
