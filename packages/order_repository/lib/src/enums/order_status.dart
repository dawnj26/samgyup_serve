/// Represents the status of an order in the system.
enum OrderStatus {
  /// Order has been placed but service hasn't started.
  pending,

  /// Order is currently being prepared or served.
  serving,

  /// Order has been completed.
  completed
  ;

  /// Returns the human-readable label for this order status.
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.serving:
        return 'Serving';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
}
