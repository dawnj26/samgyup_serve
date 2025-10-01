part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started({Table? table}) = _Started;
  const factory HomeEvent.statusChanged(SessionStatus status) = _StatusChanged;
  const factory HomeEvent.reservationCreated(String reservationId) =
      _ReservationCreated;
  const factory HomeEvent.paymentRequested({
    required String invoiceId,
  }) = _PaymentRequested;
}
