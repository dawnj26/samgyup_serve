import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'reservation_events_event.dart';
part 'reservation_events_state.dart';
part 'reservation_events_bloc.freezed.dart';

class ReservationEventsBloc
    extends Bloc<ReservationEventsEvent, ReservationEventsState> {
  ReservationEventsBloc({
    required EventRepository eventRepository,
    required String reservationId,
  }) : _repo = eventRepository,
       _reservationId = reservationId,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final EventRepository _repo;
  final String _reservationId;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationEventsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final events = await _repo.getEventsByReservationId(_reservationId);

      emit(
        state.copyWith(
          events: events,
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
