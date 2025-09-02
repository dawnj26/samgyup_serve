part of 'food_package_edit_bloc.dart';

@freezed
class FoodPackageEditState with _$FoodPackageEditState {
  const factory FoodPackageEditState.initial() = FoodPackageEditInitial;
  const factory FoodPackageEditState.loading() = FoodPackageEditLoading;
  const factory FoodPackageEditState.success() = FoodPackageEditSuccess;
  const factory FoodPackageEditState.failure({String? errorMessage}) =
      FoodPackageEditFailure;
}
