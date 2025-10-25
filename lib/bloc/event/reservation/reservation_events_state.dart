part of 'reservation_events_bloc.dart';

@freezed
abstract class ReservationEventsState with _$ReservationEventsState {
  const factory ReservationEventsState.initial({
    @Default([]) List<Event> events,
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
