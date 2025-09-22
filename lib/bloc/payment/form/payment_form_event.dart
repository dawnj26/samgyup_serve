part of 'payment_form_bloc.dart';

@freezed
class PaymentFormEvent with _$PaymentFormEvent {
  const factory PaymentFormEvent.submitted() = _Submitted;
  const factory PaymentFormEvent.priceChanged(String value) = _PriceChanged;
  const factory PaymentFormEvent.methodChanged(PaymentMethod method) =
      _MethodChanged;
  const factory PaymentFormEvent.transactionRefChanged(String value) =
      _TransactionRefChanged;
}
