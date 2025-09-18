part of 'reservation_order_bloc.dart';

@freezed
abstract class ReservationOrderEvent with _$ReservationOrderEvent {
  const factory ReservationOrderEvent.started({
    required List<CartItem<MenuItem>> items,
  }) = _Started;
}
