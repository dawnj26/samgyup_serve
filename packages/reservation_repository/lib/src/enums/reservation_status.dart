/// Represents the status of a table reservation in the restaurant system.
enum ReservationStatus {
  /// Reservation is currently active and the table is occupied
  active,

  /// Reservation has been completed and the table is available
  completed,

  /// Reservation is in the process of being cancelled
  cancelling,

  /// Reservation has been cancelled
  cancelled;

  /// Returns a human-readable label for the reservation status.
  String get label {
    switch (this) {
      case ReservationStatus.active:
        return 'Active';
      case ReservationStatus.completed:
        return 'Completed';
      case ReservationStatus.cancelled:
        return 'Cancelled';
      case ReservationStatus.cancelling:
        return 'Cancelling';
    }
  }
}
