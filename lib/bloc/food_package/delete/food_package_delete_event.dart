part of 'food_package_delete_bloc.dart';

@freezed
abstract class FoodPackageDeleteEvent with _$FoodPackageDeleteEvent {
  const factory FoodPackageDeleteEvent.started({
    required String packageId,
  }) = _Started;
}
