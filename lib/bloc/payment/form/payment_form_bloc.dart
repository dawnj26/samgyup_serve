import 'dart:developer';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/formatter.dart';

part 'payment_form_event.dart';
part 'payment_form_state.dart';
part 'payment_form_bloc.freezed.dart';

class PaymentFormBloc extends Bloc<PaymentFormEvent, PaymentFormState> {
  PaymentFormBloc({
    required BillingRepository billingRepository,
    required double totalAmount,
  }) : _billingRepository = billingRepository,
       _totalAmount = totalAmount,
       super(const _Initial()) {
    on<_PriceChanged>((event, emit) {
      final price = Price.dirty(event.value);
      emit(
        state.copyWith(
          price: price,
        ),
      );
    });

    on<_MethodChanged>((event, emit) {
      emit(
        state.copyWith(
          method: event.method,
        ),
      );
    });

    on<_TransactionRefChanged>((event, emit) {
      emit(
        state.copyWith(
          transactionRef: event.value,
        ),
      );
    });
    on<_Submitted>(_onSubmitted);
  }

  final BillingRepository _billingRepository;
  final double _totalAmount;

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<PaymentFormState> emit,
  ) async {
    final price = Price.dirty(state.price.value);
    if (price.isNotValid) {
      emit(
        state.copyWith(
          price: price,
        ),
      );
      return;
    }
    final amount = double.parse(price.value);

    log(
      'Amount: $amount, Total Amount: $_totalAmount',
      name: 'PaymentFormBloc._onSubmitted',
    );
    if (amount < _totalAmount) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage:
              'The amount must be at least ${formatToPHP(_totalAmount)}',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final payment = await _billingRepository.createPayment(
        amount: amount,
        method: state.method,
        transactionRef: state.transactionRef,
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.success,
          payment: payment,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
