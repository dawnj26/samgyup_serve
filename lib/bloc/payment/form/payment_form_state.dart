part of 'payment_form_bloc.dart';

@freezed
abstract class PaymentFormState with _$PaymentFormState {
  const factory PaymentFormState.initial({
    @Default(Price.pure()) Price price,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(PaymentMethod.cash) PaymentMethod method,
    String? transactionRef,
    String? errorMessage,
    Payment? payment,
  }) = _Initial;
}
