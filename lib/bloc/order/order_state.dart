part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure }

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState.initial({
    required Table table,
    @Default(OrderStatus.initial) OrderStatus status,
    String? errorMessage,
  }) = _Initial;
}
