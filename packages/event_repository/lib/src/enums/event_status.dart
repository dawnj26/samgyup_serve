/// Represents the different states an event can be in.
enum EventStatus {
  /// Event is waiting to be processed
  pending,

  /// Event has been successfully completed
  completed,

  /// Event was cancelled before completion
  cancelled
  ;

  /// Returns a human-readable label for the event type.
  String get label {
    switch (this) {
      case EventStatus.pending:
        return 'Pending';
      case EventStatus.completed:
        return 'Completed';
      case EventStatus.cancelled:
        return 'Cancelled';
    }
  }
}
