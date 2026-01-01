part of 'event_order_bloc.dart';

@freezed
abstract class EventOrderEvent with _$EventOrderEvent {
  const factory EventOrderEvent.started({
    required String orderId,
    required OrderStatus newStatus,
  }) = _Started;
  const factory EventOrderEvent.completedAll({
    required List<String> orderIds,
  }) = _CompletedAll;
}
