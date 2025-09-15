part of 'order_cart_bloc.dart';

enum OrderCartStatus { initial, loading, success, failure }

@freezed
abstract class OrderCartState with _$OrderCartState {
  const factory OrderCartState.initial({
    @Default(OrderCartStatus.initial) OrderCartStatus status,
    @Default([]) List<CartItem<MenuItem>> menuItems,
    @Default([]) List<CartItem<FoodPackage>> packages,
    @Default(0) double totalPrice,
  }) = _Initial;
}
