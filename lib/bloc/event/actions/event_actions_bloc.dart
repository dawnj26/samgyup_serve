import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_actions_event.dart';
part 'event_actions_state.dart';
part 'event_actions_bloc.freezed.dart';

class EventActionsBloc extends Bloc<EventActionsEvent, EventActionsState> {
  EventActionsBloc({
    required EventRepository eventRepository,
  }) : _repo = eventRepository,
       super(const _Initial()) {
    on<_Completed>(_onCompleted);
    on<_Canceled>(_onCanceled);
  }

  final EventRepository _repo;

  Future<void> _onCompleted(
    _Completed event,
    Emitter<EventActionsState> emit,
  ) async {
    emit(state.copyWith(status: EventActionsStatus.loading));
    try {
      await _repo.completeEvent(event.event.id);
      // await LogRepository.instance.logAction(
      //   action: LogAction.update,
      //   message: 'Event marked as completed',
      //   resourceId: event.event.id,
      //   details: 'Event ID: ${event.event.id}',
      // );
      emit(
        state.copyWith(
          status: EventActionsStatus.success,
          message: 'Event marked as completed',
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventActionsStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventActionsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCanceled(
    _Canceled event,
    Emitter<EventActionsState> emit,
  ) async {
    emit(state.copyWith(status: EventActionsStatus.loading));
    try {
      await _repo.cancelEvent(event.event.id);
      emit(
        state.copyWith(
          status: EventActionsStatus.success,
          message: 'Event canceled',
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventActionsStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventActionsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
