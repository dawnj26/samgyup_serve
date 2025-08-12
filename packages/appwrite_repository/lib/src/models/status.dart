/// Enum representing different connection states.
enum Status {
  /// The connection is idle, not currently loading or processing.
  idle,

  /// The connection is currently loading data.
  loading,

  /// The connection has successfully completed loading data.
  success,

  /// The connection encountered an error while loading data.
  error,
}
