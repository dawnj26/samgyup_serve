part of 'event_list_bloc.dart';

enum EventListStatus { initial, loading, success, failure }

@freezed
abstract class EventListState with _$EventListState {
  const factory EventListState.initial({
    @Default(EventListStatus.initial) EventListStatus status,
    @Default([]) List<Event> events,
    @Default(EventStatus.pending) EventStatus filter,
    Event? latestEvent,
    String? errorMessage,
  }) = _Initial;
}
