import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ReservationRepository reservationRepo,
  }) : _reservationRepo = reservationRepo,
       super(const _Initial()) {
    on<_StatusChanged>(_onStatusChanged);
    on<_Started>(_onStarted);
    on<_ReservationCreated>(_onReservationCreated);
  }

  final ReservationRepository _reservationRepo;

  Future<void> _onReservationCreated(
    _ReservationCreated event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        session: SessionStatus.reservation,
        reservationId: event.reservationId,
      ),
    );
  }

  Future<void> _onStatusChanged(
    _StatusChanged event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(session: event.status));
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<HomeState> emit,
  ) async {
    if (event.tableId == null) return;

    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final reservation = await _reservationRepo.getCurrentReservation(
        event.tableId!,
      );
      if (reservation != null) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            session: SessionStatus.reservation,
            reservationId: reservation.id,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            session: SessionStatus.initial,
          ),
        );
      }
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          session: SessionStatus.initial,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          session: SessionStatus.initial,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
