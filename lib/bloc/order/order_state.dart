part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure }

@freezed
abstract class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
}
