part of 'food_package_inventory_bloc.dart';

@freezed
abstract class FoodPackageInventoryEvent with _$FoodPackageInventoryEvent {
  const factory FoodPackageInventoryEvent.started({
    required List<String> menuIds,
  }) = _Started;
}
