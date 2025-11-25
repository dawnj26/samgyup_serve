part of 'food_package_details_bloc.dart';

@freezed
class FoodPackageDetailsEvent with _$FoodPackageDetailsEvent {
  const factory FoodPackageDetailsEvent.started() = _Started;
  const factory FoodPackageDetailsEvent.refreshed() = _Refreshed;
  const factory FoodPackageDetailsEvent.changed([FoodPackageItem? package]) =
      _Changed;
}
