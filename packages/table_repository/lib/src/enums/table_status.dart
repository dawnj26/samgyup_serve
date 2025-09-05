/// Represents the current operational status of a restaurant table.
///
/// This enum defines the possible states a table can be in during
/// restaurant operations, affecting availability for new customers.
enum TableStatus {
  /// Table is ready and available for new customers
  available,

  /// Table is currently being used by customers
  occupied,

  /// Table is temporarily unavailable due to maintenance or other issues
  outOfService,
}

/// Extension on [TableStatus] to provide human-readable labels.
extension TableStatusExtension on TableStatus {
  /// Returns a user-friendly label for the table status.
  ///
  /// Used for displaying status information in the UI.
  String get label {
    switch (this) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.outOfService:
        return 'Out of Service';
    }
  }
}
