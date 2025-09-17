import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const _Initial()) {
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
    emit(state.copyWith(status: event.status));
  }
}
