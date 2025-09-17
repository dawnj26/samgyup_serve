part of 'order_list_bloc.dart';

enum OrderListStatus { initial, loading, success, failure }

@freezed
abstract class OrderListState with _$OrderListState {
  const factory OrderListState.initial({
    @Default([]) List<String> orderIds,
    @Default([]) List<CartItem<FoodPackage>> packages,
    @Default([]) List<CartItem<MenuItem>> menuItems,
    @Default(OrderListStatus.initial) OrderListStatus status,
    String? errorMessage,
  }) = _Initial;
}
