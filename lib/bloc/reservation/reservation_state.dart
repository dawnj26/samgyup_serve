part of 'reservation_bloc.dart';

enum ReservationStatus { initial, loading, success, failure }

@freezed
abstract class ReservationState with _$ReservationState {
  const factory ReservationState.initial({
    required Reservation reservation,
    required Invoice invoice,
    required Table table,
    @Default(ReservationStatus.initial) ReservationStatus status,
    String? errorMessage,
  }) = _Initial;
}
