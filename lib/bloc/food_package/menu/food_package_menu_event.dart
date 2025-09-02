part of 'food_package_menu_bloc.dart';

@freezed
abstract class FoodPackageMenuEvent with _$FoodPackageMenuEvent {
  const factory FoodPackageMenuEvent.started({
    required List<String> menuIds,
  }) = _Started;
}
