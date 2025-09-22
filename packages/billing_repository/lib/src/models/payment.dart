import 'package:billing_repository/src/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

/// Represents a payment transaction in the billing system.
///
/// Contains payment details including amount, method, and transaction metadata.
@freezed
abstract class Payment with _$Payment {
  /// Creates a new payment with the specified details.
  ///
  /// [amount] - The payment amount (required)
  /// [method] - The payment method used (required)
  /// [id] - Unique identifier for the payment (defaults to empty string)
  /// [transactionRef] - External transaction reference (optional)
  /// [createdAt] - Payment creation timestamp (optional)
  /// [updatedAt] - Payment last update timestamp (optional)
  const factory Payment({
    required double amount,
    required PaymentMethod method,
    @Default('') String id,
    String? transactionRef,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Payment;

  /// Creates an empty payment with default values.
  ///
  /// Uses amount of 0 and cash payment method.
  factory Payment.empty() =>
      const Payment(amount: 0, method: PaymentMethod.cash);

  /// Creates a payment from JSON data.
  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
