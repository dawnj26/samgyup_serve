part of 'order_bloc.dart';

@freezed
abstract class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started({
    required String tableId,
    required List<CartItem<MenuItem>> menuItems,
    required List<CartItem<FoodPackage>> packages,
  }) = _Started;
}
