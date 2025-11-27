import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/log_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';
part 'invoice_bloc.freezed.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc({
    required BillingRepository billingRepository,
    required String invoiceId,
    required ReservationRepository reservationRepository,
    required TableRepository tableRepository,
  }) : _billingRepository = billingRepository,
       _reservationRepository = reservationRepository,
       _tableRepository = tableRepository,
       _invoiceId = invoiceId,
       super(
         _Initial(
           invoices: Invoice.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Paid>(_onPaid);
  }

  final BillingRepository _billingRepository;
  final ReservationRepository _reservationRepository;
  final TableRepository _tableRepository;
  final String _invoiceId;

  Future<void> _onStarted(
    _Started event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(status: InvoiceBlocStatus.loading));

    try {
      final invoice = await _billingRepository.getInvoiceById(_invoiceId);
      emit(
        state.copyWith(
          status: InvoiceBlocStatus.success,
          invoices: invoice,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: InvoiceBlocStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: InvoiceBlocStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPaid(
    _Paid event,
    Emitter<InvoiceState> emit,
  ) async {
    emit(state.copyWith(paymentStatus: PaymentStatus.processing));

    try {
      final invoice = await _billingRepository.markAsPaid(
        invoice: state.invoices,
        payment: event.payment,
      );
      final reservation = await _reservationRepository
          .getReservationByInvoiceId(invoice.id);
      await _reservationRepository.updateReservation(
        reservation: reservation.copyWith(status: ReservationStatus.completed),
      );
      try {
        await _tableRepository.updateTableStatus(
          tableId: reservation.tableId,
          status: TableStatus.available,
        );
      } on Exception {
        //
      }

      await LogRepository.instance.logAction(
        action: LogAction.update,
        message: 'Invoice marked as paid: ${invoice.id}',
        resourceId: invoice.id,
        details: 'Invoice ID: ${invoice.id}, Amount: ${invoice.totalAmount}',
      );

      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.completed,
          invoices: invoice,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.failed,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          paymentStatus: PaymentStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
