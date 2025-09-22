part of 'invoice_bloc.dart';

enum InvoiceBlocStatus {
  initial,
  loading,
  success,
  failure,
}

enum PaymentStatus {
  initial,
  processing,
  completed,
  failed,
}

@freezed
abstract class InvoiceState with _$InvoiceState {
  const factory InvoiceState.initial({
    required Invoice invoices,
    @Default(InvoiceBlocStatus.initial) InvoiceBlocStatus status,
    @Default(PaymentStatus.initial) PaymentStatus paymentStatus,
    String? errorMessage,
  }) = _Initial;
}
