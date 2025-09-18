part of 'timer_bloc.dart';

@freezed
abstract class TimerEvent with _$TimerEvent {
  const factory TimerEvent.started({
    required DateTime startTime,
    required Duration duration,
  }) = _Started;
  const factory TimerEvent.tick({required Duration duration}) = _Tick;
}
