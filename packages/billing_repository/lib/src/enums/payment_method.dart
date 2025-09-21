/// Represents the available payment methods for transactions.
enum PaymentMethod {
  /// Cash payment method
  cash,

  /// GCash digital wallet payment method
  gcash;

  /// Returns a human-readable label for the payment method.
  String get label {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.gcash:
        return 'GCash';
    }
  }
}
