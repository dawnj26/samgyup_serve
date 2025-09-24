import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';

part 'reservation_total_event.dart';
part 'reservation_total_state.dart';
part 'reservation_total_bloc.freezed.dart';

class ReservationTotalBloc
    extends Bloc<ReservationTotalEvent, ReservationTotalState> {
  ReservationTotalBloc({
    required ReservationRepository reservationRepository,
  }) : _reservationRepository = reservationRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final ReservationRepository _reservationRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationTotalState> emit,
  ) async {
    emit(state.copyWith(status: ReservationTotalStatus.loading));

    try {
      final todayTotal = await _reservationRepository
          .getTodayTotalReservations();

      emit(
        state.copyWith(
          status: ReservationTotalStatus.success,
          todayTotal: todayTotal,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: ReservationTotalStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReservationTotalStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
