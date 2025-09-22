part of 'event_actions_bloc.dart';

enum EventActionsStatus { initial, loading, success, failure }

@freezed
abstract class EventActionsState with _$EventActionsState {
  const factory EventActionsState.initial({
    @Default(EventActionsStatus.initial) EventActionsStatus status,
    @Default('') String message,
    String? errorMessage,
  }) = _Initial;
}
