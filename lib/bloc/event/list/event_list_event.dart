part of 'event_list_bloc.dart';

@freezed
abstract class EventListEvent with _$EventListEvent {
  const factory EventListEvent.started() = _Started;
  const factory EventListEvent.refreshed() = _Refreshed;
  const factory EventListEvent.created({
    required Event event,
  }) = _Created;
  const factory EventListEvent.updated({
    required Event event,
  }) = _Updated;
  const factory EventListEvent.deleted({
    required Event event,
  }) = _Deleted;
}
