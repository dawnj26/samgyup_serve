part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure }

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState.initial({
    @Default(OrderStatus.initial) OrderStatus status,
    @Default('') String reservationId,
    @Default([]) List<Order> orders,
    String? errorMessage,
  }) = _Initial;
}
