part of 'food_package_edit_bloc.dart';

@freezed
class FoodPackageEditEvent with _$FoodPackageEditEvent {
  const factory FoodPackageEditEvent.started() = _Started;
}
