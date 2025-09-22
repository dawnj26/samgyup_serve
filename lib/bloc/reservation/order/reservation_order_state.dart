part of 'reservation_order_bloc.dart';

enum ReservationOrderStatus { initial, loading, success, failure, pure }

@freezed
abstract class ReservationOrderState with _$ReservationOrderState {
  const factory ReservationOrderState.initial({
    @Default(ReservationOrderStatus.initial) ReservationOrderStatus status,
    @Default([]) List<Order> orders,
    String? errorMessage,
  }) = _Initial;
}
