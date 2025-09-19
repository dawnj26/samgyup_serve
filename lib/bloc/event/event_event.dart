part of 'event_bloc.dart';

@freezed
abstract class EventEvent with _$EventEvent {
  const factory EventEvent.created({
    required String reservationId,
    required int tableNumber,
    required Map<String, dynamic> payload,
  }) = _Created;
}
