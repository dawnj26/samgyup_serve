part of 'food_package_bloc.dart';

@freezed
class FoodPackageEvent with _$FoodPackageEvent {
  const factory FoodPackageEvent.started() = _Started;
}
