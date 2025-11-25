/// Enumeration of resources that can be logged in the system.
///
/// Each resource type represents a different domain or entity that actions
/// can be tracked and logged for audit purposes.
enum LogResource {
  /// Logs related to inventory management and stock operations.
  inventory,

  /// Logs related to events and event scheduling.
  event,

  /// Logs related to user accounts and authentication.
  user,

  /// Logs related to billing and payment transactions.
  billing,

  /// Logs related to system settings and configuration.
  settings,

  /// Logs related to customer orders.
  order,

  /// Logs related to package management and bundling.
  package,

  /// Logs related to table reservations.
  reservation,

  /// Logs related to table management.
  table;

  /// Returns a human-readable label for this log resource.
  String get label {
    switch (this) {
      case LogResource.inventory:
        return 'Inventory';
      case LogResource.event:
        return 'Event';
      case LogResource.user:
        return 'User';
      case LogResource.billing:
        return 'Billing';
      case LogResource.settings:
        return 'Settings';
      case LogResource.order:
        return 'Order';
      case LogResource.package:
        return 'Package';
      case LogResource.reservation:
        return 'Reservation';
      case LogResource.table:
        return 'Table';
    }
  }
}
