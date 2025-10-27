import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';

part 'cancel_event.dart';
part 'cancel_state.dart';
part 'cancel_bloc.freezed.dart';

class CancelBloc extends Bloc<CancelEvent, CancelState> {
  CancelBloc({
    required ReservationRepository reservationRepository,
  }) : _reservationRepository = reservationRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Cancelled>(_onCancelled);
  }

  final ReservationRepository _reservationRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<CancelState> emit,
  ) async {
    emit(state.copyWith(status: CancelStatus.accepting));

    try {
      await _reservationRepository.cancelReservation(event.reservationId);
      emit(
        state.copyWith(
          status: CancelStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: CancelStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CancelStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCancelled(
    _Cancelled event,
    Emitter<CancelState> emit,
  ) async {
    emit(state.copyWith(status: CancelStatus.declining));

    try {
      await _reservationRepository.cancelReservation(
        event.reservationId,
        accepted: false,
      );
      emit(
        state.copyWith(
          status: CancelStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: CancelStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: CancelStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
