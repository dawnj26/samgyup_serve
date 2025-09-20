part of 'payment_order_bloc.dart';

enum PaymentOrderStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class PaymentOrderState with _$PaymentOrderState {
  const factory PaymentOrderState.initial({
    @Default(PaymentOrderStatus.initial) PaymentOrderStatus status,
    String? message,
  }) = _Initial;
}
