import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'reservation_event.dart';
part 'reservation_state.dart';
part 'reservation_bloc.freezed.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  ReservationBloc({
    required ReservationRepository reservationRepository,
    required BillingRepository billingRepository,
    required TableRepository tableRepository,
  }) : _reservationRepo = reservationRepository,
       _tableRepo = tableRepository,
       _billingRepo = billingRepository,
       super(
         _Initial(
           reservation: Reservation.empty(),
           invoice: Invoice.empty(),
           table: Table.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
  }

  final ReservationRepository _reservationRepo;
  final BillingRepository _billingRepo;
  final TableRepository _tableRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: ReservationStatus.loading));

    try {
      final reservation = await _reservationRepo.getReservationById(
        event.reservationId,
      );
      final invoice = await _billingRepo.getInvoiceById(reservation.invoiceId);
      final table = await _tableRepo.fetchTable(reservation.tableId);

      emit(
        state.copyWith(
          reservation: reservation,
          status: ReservationStatus.success,
          invoice: invoice,
          table: table,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: ReservationStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReservationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
