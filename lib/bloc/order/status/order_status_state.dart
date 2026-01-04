part of 'order_status_bloc.dart';

@freezed
abstract class OrderStatusState with _$OrderStatusState {
  const factory OrderStatusState.initial({
    required OrderStatus status,
  }) = _Initial;
}
