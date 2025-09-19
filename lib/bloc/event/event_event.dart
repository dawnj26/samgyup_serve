part of 'event_bloc.dart';

@freezed
abstract class EventEvent with _$EventEvent {
  const factory EventEvent.started() = _Started;
  const factory EventEvent.orderCreated({
    required String reservationId,
    required int tableNumber,
    required List<Order> orders,
  }) = _OrderCreated;
  const factory EventEvent.itemsAdded({
    required String reservationId,
    required int tableNumber,
    required List<Order> orders,
  }) = _ItemsAdded;
  const factory EventEvent.refillRequested({
    required String reservationId,
    required int tableNumber,
    required List<CartItem<MenuItem>> items,
  }) = _RefillRequested;
  const factory EventEvent.paymentRequested({
    required String reservationId,
    required int tableNumber,
    required Map<String, dynamic> payload,
  }) = _PaymentRequested;
}
