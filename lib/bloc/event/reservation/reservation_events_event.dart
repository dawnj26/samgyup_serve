part of 'reservation_events_bloc.dart';

@freezed
abstract class ReservationEventsEvent with _$ReservationEventsEvent {
  const factory ReservationEventsEvent.started() = _Started;
}
