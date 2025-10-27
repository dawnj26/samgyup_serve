part of 'cancel_bloc.dart';

@freezed
abstract class CancelEvent with _$CancelEvent {
  const factory CancelEvent.started({
    required String reservationId,
  }) = _Started;
  const factory CancelEvent.cancelled({
    required String reservationId,
  }) = _Cancelled;
}
