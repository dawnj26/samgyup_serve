part of 'order_cart_bloc.dart';

@freezed
class OrderCartEvent with _$OrderCartEvent {
  const factory OrderCartEvent.started() = _Started;
}