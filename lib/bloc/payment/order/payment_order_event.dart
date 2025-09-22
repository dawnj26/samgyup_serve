part of 'payment_order_bloc.dart';

@freezed
abstract class PaymentOrderEvent with _$PaymentOrderEvent {
  const factory PaymentOrderEvent.started({
    required String invoiceId,
  }) = _Started;
  const factory PaymentOrderEvent.completed() = _Completed;
}
