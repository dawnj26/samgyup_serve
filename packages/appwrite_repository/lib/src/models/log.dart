/// A data model for holding log entries.
class Log {
  /// Creates a new [Log] instance.
  const Log({
    required this.date,
    required this.status,
    required this.method,
    required this.path,
    required this.response,
  });

  /// The date and time when the log entry was created.
  final String date;

  /// The HTTP status code of the log entry.
  final int status;

  /// The HTTP method used in the log entry (e.g., GET, POST).
  final String method;

  /// The path of the request that generated the log entry.
  final String path;

  /// The response body of the log entry.
  final String response;
}
