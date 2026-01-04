import 'dart:convert';
import 'dart:developer';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required ReservationRepository reservationRepo,
    required BillingRepository billingRepo,
    required EventRepository eventRepo,
    Table? table,
  }) : _reservationRepo = reservationRepo,
       _eventRepo = eventRepo,
       _billingRepo = billingRepo,
       super(
         _Initial(
           table: table,
         ),
       ) {
    on<_StatusChanged>(_onStatusChanged);
    on<_Started>(_onStarted);
    on<_ReservationCreated>(_onReservationCreated);
    on<_PaymentRequested>((event, emit) {
      emit(
        state.copyWith(
          invoiceId: event.invoiceId,
          session: SessionStatus.payment,
        ),
      );
    });
    on<_CustomerCountChanged>((event, emit) {
      emit(
        state.copyWith(
          customerCount: event.customerCount,
        ),
      );
    });
  }

  final ReservationRepository _reservationRepo;
  final EventRepository _eventRepo;
  final BillingRepository _billingRepo;

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
    emit(state.copyWith(status: HomeStatus.loading));

    if (state.table == null) {
      emit(
        state.copyWith(
          status: HomeStatus.success,
          session: SessionStatus.initial,
        ),
      );
      return;
    }

    try {
      final reservation = await _reservationRepo.getCurrentReservation(
        state.table!.id,
      );

      if (reservation == null) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            session: SessionStatus.initial,
          ),
        );
        return;
      }

      final invoiceId = await _getInvoiceIdFromPaymentEvent(
        state.table!.number,
      );

      if (invoiceId == null) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            session: SessionStatus.reservation,
            reservationId: reservation.id,
          ),
        );
        return;
      }

      final invoice = await _billingRepo.getInvoiceById(invoiceId);

      if (invoice.status == InvoiceStatus.pending) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            session: SessionStatus.payment,
            reservationId: reservation.id,
            invoiceId: invoice.id,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          status: HomeStatus.success,
          session: SessionStatus.initial,
        ),
      );
    } on ResponseException catch (e) {
      log('HomeBloc _onStarted', error: e);
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          session: SessionStatus.initial,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      log('HomeBloc _onStarted', error: e);
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          session: SessionStatus.initial,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<String?> _getInvoiceIdFromPaymentEvent(int tableNumber) async {
    final paymentEvent = await _eventRepo.getCurrentPaymentEvent(tableNumber);

    if (paymentEvent == null) return null;

    final json = jsonDecode(paymentEvent.payload) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>;
    return data['invoiceId'] as String;
  }
}
