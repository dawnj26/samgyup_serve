part of 'reservation_refill_bloc.dart';

enum ReservationRefillStatus {
  initial,
  loading,
  success,
  failure,
  timeLimitExceeded,
}

@freezed
abstract class ReservationRefillState with _$ReservationRefillState {
  const factory ReservationRefillState.initial({
    @Default(ReservationRefillStatus.initial) ReservationRefillStatus status,
    @Default([]) List<CartItem<InventoryItem>> cartItems,
    String? message,
  }) = _Initial;
}
