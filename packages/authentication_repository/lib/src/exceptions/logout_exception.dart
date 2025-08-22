/// Thrown during the logout process if a failure occurs.
class LogoutException implements Exception {
  /// Create a [LogoutException] with an optional error message.
  const LogoutException([this.message = 'Logout failed.']);

  /// The error message.
  final String message;
}
