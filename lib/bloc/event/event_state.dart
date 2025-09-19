part of 'event_bloc.dart';

enum EventStatus { initial, loading, success, failure }

@freezed
abstract class EventState with _$EventState {
  const factory EventState.initial({
    @Default(EventStatus.initial) EventStatus status,
    String? errorMessage,
  }) = _Initial;
}
