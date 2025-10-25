/// Represents different types of events
/// that can occur in the restaurant system.
enum EventType {
  /// Triggered when a new order is created by a customer.
  orderCreated,

  /// Triggered when items are added to an existing order.
  itemsAdded,

  /// Triggered when a customer requests a refill for drinks or side dishes.
  refillRequested,

  /// Triggered when a customer cancels their order.
  orderCancelled,

  /// Triggered when a customer requests to pay for their order.
  paymentRequested;

  /// Returns a human-readable label for the event type.
  String get label {
    switch (this) {
      case EventType.orderCreated:
        return 'Order Created';
      case EventType.itemsAdded:
        return 'Items Added';
      case EventType.refillRequested:
        return 'Refill Requested';
      case EventType.paymentRequested:
        return 'Payment Requested';
      case EventType.orderCancelled:
        return 'Order Cancelled';
    }
  }
}
