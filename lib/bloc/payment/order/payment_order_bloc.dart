import 'package:appwrite/appwrite.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_order_event.dart';
part 'payment_order_state.dart';
part 'payment_order_bloc.freezed.dart';

class PaymentOrderBloc extends Bloc<PaymentOrderEvent, PaymentOrderState> {
  PaymentOrderBloc({
    required BillingRepository billingRepository,
  }) : _billingRepository = billingRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Completed>((event, emit) {
      emit(state.copyWith(status: PaymentOrderStatus.success));
    });
  }

  final BillingRepository _billingRepository;
  RealtimeSubscription? _subscription;

  Future<void> _onStarted(
    _Started event,
    Emitter<PaymentOrderState> emit,
  ) async {
    try {
      await _subscription?.close();
      _subscription = _billingRepository.invoiceState(event.invoiceId);

      _subscription?.stream.listen((response) {
        final invoice = Invoice.fromJson(
          response.payload,
        );

        if (invoice.status == InvoiceStatus.paid) {
          add(const PaymentOrderEvent.completed());
        }
      });
    } on AppwriteException catch (e) {
      emit(
        state.copyWith(
          status: PaymentOrderStatus.failure,
          message: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: PaymentOrderStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.close();
    return super.close();
  }
}
