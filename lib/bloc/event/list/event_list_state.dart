part of 'event_list_bloc.dart';

enum EventListStatus { initial, loading, success, failure }

@freezed
abstract class EventListState with _$EventListState {
  const factory EventListState.initial({
    @Default(EventListStatus.initial) EventListStatus status,
    @Default([]) List<Event> events,
    String? errorMessage,
  }) = _Initial;
}
