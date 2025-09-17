import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_event.dart';
part 'timer_state.dart';
part 'timer_bloc.freezed.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Tick>(_onTick);
  }

  Timer? _ticker;

  Future<void> _onStarted(
    _Started event,
    Emitter<TimerState> emit,
  ) async {
    _ticker?.cancel();
    emit(
      state.copyWith(
        duration: event.duration,
        isFinished: false,
      ),
    );

    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final duration = event.startTime
          .add(event.duration)
          .difference(DateTime.now());

      add(TimerEvent.tick(duration: duration));
    });
  }

  Future<void> _onTick(
    _Tick event,
    Emitter<TimerState> emit,
  ) async {
    if (event.duration.isNegative) {
      _ticker?.cancel();
      emit(state.copyWith(duration: Duration.zero, isFinished: true));
    } else {
      emit(state.copyWith(duration: event.duration, isFinished: false));
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
