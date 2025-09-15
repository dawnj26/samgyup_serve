import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_event.dart';
part 'activity_state.dart';
part 'activity_bloc.freezed.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    Duration inactivityDuration = const Duration(minutes: 5),
  }) : _inactivityDuration = inactivityDuration,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Stopped>(_onStopped);
    on<_Reset>(_onReset);
  }

  Timer? _timer;
  final Duration _inactivityDuration;

  void _onReset(_Reset event, Emitter<ActivityState> emit) {
    emit(state.copyWith(status: ActivityStatus.initial));
    _stopTimer();
  }

  void _onStopped(_Stopped event, Emitter<ActivityState> emit) {
    emit(state.copyWith(status: ActivityStatus.inactive));
  }

  void _onStarted(_Started event, Emitter<ActivityState> emit) {
    emit(state.copyWith(status: ActivityStatus.active));
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(_inactivityDuration, () {
      add(const ActivityEvent.stopped());
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
