import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';

part 'reservation_cancel_event.dart';
part 'reservation_cancel_state.dart';
part 'reservation_cancel_bloc.freezed.dart';

class ReservationCancelBloc
    extends Bloc<ReservationCancelEvent, ReservationCancelState> {
  ReservationCancelBloc({
    required ReservationRepository reservationRepository,
  }) : _reservationRepository = reservationRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Confirmed>(_onConfirmed);
    on<_Cancelled>(_onCancelled);
  }

  final ReservationRepository _reservationRepository;
  RealtimeSubscription? _subscription;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationCancelState> emit,
  ) async {
    emit(state.copyWith(status: ReservationCancelStatus.loading));

    try {
      final r = await _reservationRepository.getReservationById(
        event.reservationId,
      );
      if (r.status != ReservationStatus.cancelling) {
        await _reservationRepository.updateReservation(
          reservation: r.copyWith(
            status: ReservationStatus.cancelling,
          ),
        );
      }

      await _subscription?.close();
      _subscription = _reservationRepository.reservationState(
        event.reservationId,
      );

      _subscription?.stream.listen((response) async {
        final reservation = Reservation.fromJson(
          response.payload,
        );

        if (reservation.status == ReservationStatus.cancelled) {
          add(const ReservationCancelEvent.confirmed());
        }

        if (reservation.status == ReservationStatus.active) {
          add(const ReservationCancelEvent.cancelled());
        }
      });

      emit(state.copyWith(status: ReservationCancelStatus.inProgress));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: ReservationCancelStatus.failure,
          message: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReservationCancelStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  void _onConfirmed(
    _Confirmed event,
    Emitter<ReservationCancelState> emit,
  ) {
    emit(state.copyWith(status: ReservationCancelStatus.success));
  }

  void _onCancelled(
    _Cancelled event,
    Emitter<ReservationCancelState> emit,
  ) {
    emit(state.copyWith(status: ReservationCancelStatus.cancelled));
  }

  @override
  Future<void> close() async {
    await _subscription?.close();
    return super.close();
  }
}
