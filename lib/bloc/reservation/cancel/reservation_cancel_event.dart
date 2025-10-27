part of 'reservation_cancel_bloc.dart';

@freezed
abstract class ReservationCancelEvent with _$ReservationCancelEvent {
  const factory ReservationCancelEvent.started({
    required String reservationId,
  }) = _Started;
  const factory ReservationCancelEvent.confirmed() = _Confirmed;
  const factory ReservationCancelEvent.cancelled() = _Cancelled;
}
