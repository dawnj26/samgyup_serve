part of 'activity_bloc.dart';

@freezed
class ActivityEvent with _$ActivityEvent {
  const factory ActivityEvent.started() = _Started;
  const factory ActivityEvent.stopped() = _Stopped;
  const factory ActivityEvent.reset() = _Reset;
}
