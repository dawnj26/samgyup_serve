part of 'reservation_cancel_bloc.dart';

enum ReservationCancelStatus {
  initial,
  loading,
  inProgress,
  cancelled,
  success,
  failure,
}

@freezed
abstract class ReservationCancelState with _$ReservationCancelState {
  const factory ReservationCancelState.initial({
    @Default(ReservationCancelStatus.initial) ReservationCancelStatus status,
    String? message,
  }) = _Initial;
}
