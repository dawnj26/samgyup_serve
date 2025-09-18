part of 'reservation_bloc.dart';

@freezed
abstract class ReservationEvent with _$ReservationEvent {
  const factory ReservationEvent.started({
    required String reservationId,
  }) = _Started;
  const factory ReservationEvent.refreshed() = _Refreshed;
}
