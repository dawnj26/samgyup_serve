part of 'event_actions_bloc.dart';

@freezed
abstract class EventActionsEvent with _$EventActionsEvent {
  const factory EventActionsEvent.completed({
    required String eventId,
  }) = _Completed;
  const factory EventActionsEvent.canceled({
    required String eventId,
  }) = _Canceled;
}
