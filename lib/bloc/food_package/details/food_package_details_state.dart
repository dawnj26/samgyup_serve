part of 'food_package_details_bloc.dart';

@freezed
abstract class FoodPackageDetailsState with _$FoodPackageDetailsState {
  const factory FoodPackageDetailsState.initial({
    required FoodPackage package,
  }) = FoodPackageDetailsInitial;
}
