part of 'order_status_bloc.dart';

@freezed
class OrderStatusEvent with _$OrderStatusEvent {
  const factory OrderStatusEvent.started() = _Started;
  const factory OrderStatusEvent.changed({
    required OrderStatus status,
  }) = _Changed;
}
