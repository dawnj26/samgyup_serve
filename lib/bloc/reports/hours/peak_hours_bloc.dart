import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'peak_hours_event.dart';
part 'peak_hours_state.dart';
part 'peak_hours_bloc.freezed.dart';

class PeakHoursBloc extends Bloc<PeakHoursEvent, PeakHoursState> {
  PeakHoursBloc({
    required ReservationRepository reservationRepository,
  }) : _reservationRepository = reservationRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final ReservationRepository _reservationRepository;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<PeakHoursState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final peakHours = await _reservationRepository
          .getHourlyReservationCounts();

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          peakHours: peakHours,
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
