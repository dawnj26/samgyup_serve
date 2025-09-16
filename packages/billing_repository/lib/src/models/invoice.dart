import 'package:billing_repository/src/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

/// {@template invoice}
/// Represents an invoice for a restaurant table order.
///
/// Contains billing information including order details, amounts,
/// and payment tracking for restaurant transactions.
/// {@endtemplate}
@freezed
abstract class Invoice with _$Invoice {
  /// {@macro invoice}
  factory Invoice({
    /// The generated code for this invoice
    required String code,

    /// List of order IDs included in this invoice
    required List<String> orderIds,

    /// Total amount including tax and after discounts
    required double totalAmount,

    /// Amount of tax applied to the invoice
    required double taxAmount,

    /// Amount of discount applied to the invoice
    required double discountAmount,

    /// Subtotal amount before tax and discounts
    required double subtotalAmount,

    /// Current status of the invoice
    required InvoiceStatus status,

    /// Number to track invoice sequence
    required int number,

    /// Amount that has been paid towards this invoice
    @Default(0) double amountPaid,

    /// ID of the Invoice
    @Default('') String id,

    /// Payment transaction ID if payment has been processed
    String? paymentId,

    /// When the invoice was created
    DateTime? createdAt,

    /// When the invoice was last updated
    DateTime? updatedAt,
  }) = _Invoice;

  /// Creates an Invoice from a JSON map.
  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
