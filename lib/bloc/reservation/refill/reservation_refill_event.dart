part of 'reservation_refill_bloc.dart';

@freezed
abstract class ReservationRefillEvent with _$ReservationRefillEvent {
  const factory ReservationRefillEvent.started({
    required List<CartItem<MenuItem>> cartItems,
  }) = _Started;
}
