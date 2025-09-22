/// Represents the status of an invoice in the billing system.
enum InvoiceStatus {
  /// Invoice has been created but payment is pending
  pending,

  /// Invoice has been successfully paid
  paid,

  /// Invoice has been cancelled or voided
  voided;

  /// Returns a human-readable label for the invoice status.
  String get label {
    switch (this) {
      case InvoiceStatus.pending:
        return 'Pending';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.voided:
        return 'Voided';
    }
  }
}
