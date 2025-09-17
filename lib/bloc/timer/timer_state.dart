part of 'timer_bloc.dart';

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState.initial({
    @Default(Duration.zero) Duration duration,
    @Default(true) bool isFinished,
  }) = _Initial;
}
