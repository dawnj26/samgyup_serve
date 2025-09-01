/// Exception thrown when an HTTP response indicates an error.
///
/// This exception provides error messages based on HTTP status codes:
/// - 2xx range: Success (typically shouldn't throw exceptions)
/// - 4xx range: Client errors (invalid requests, authentication issues, etc.)
/// - 5xx range: Server errors (Appwrite service issues)
class ResponseException implements Exception {
  /// Creates a [ResponseException] with the given [message].
  const ResponseException(this.message);

  /// Creates a [ResponseException] from an HTTP status [code].
  ///
  /// Automatically generates error messages based on common
  /// HTTP status codes:
  ///
  /// **Client Errors (4xx):**
  /// - 400: Invalid request
  /// - 401: Authentication required
  /// - 403: Access denied
  /// - 404: Resource not found
  /// - 409: Conflict (resource already exists)
  /// - 422: Invalid data
  /// - 429: Rate limited
  ///
  /// **Server Errors (5xx):**
  /// - 500: Internal server error
  /// - 502: Service unavailable
  /// - 503: Service unavailable
  /// - 504: Request timeout
  ///
  /// For unknown codes within 4xx/5xx ranges, generic messages are provided.
  ///
  /// Example:
  /// ```dart
  /// final exception = ResponseException.fromCode(404);
  /// print(exception.message); // "The requested resource was not found."
  /// ```
  factory ResponseException.fromCode(int code) {
    // 2xx range - Success (shouldn't throw exceptions)
    if (code >= 200 && code < 300) {
      return const ResponseException('Request completed successfully');
    }

    // 4xx range - Client errors
    if (code >= 400 && code < 500) {
      switch (code) {
        case 400:
          return const ResponseException(
            'Invalid request. Please check your input and try again.',
          );
        case 401:
          return const ResponseException(
            'Authentication required.',
          );
        case 403:
          return const ResponseException(
            "Access denied. You don't have permission to perform this action.",
          );
        case 404:
          return const ResponseException(
            'The requested resource was not found.',
          );
        case 409:
          return const ResponseException(
            'Conflict detected. The resource already exists or is in use.',
          );
        case 422:
          return const ResponseException(
            'Invalid data provided. Please check your input.',
          );
        case 429:
          return const ResponseException(
            'Too many requests. Please wait a moment and try again.',
          );
        default:
          return ResponseException(
            'Unknown error: $code. Please check your input and try again.',
          );
      }
    }

    // 5xx range - Server errors
    if (code >= 500 && code < 600) {
      switch (code) {
        case 500:
          return const ResponseException(
            'Internal server error. Please try again later.',
          );
        case 502:
          return const ResponseException(
            'Service temporarily unavailable. Please try again later.',
          );
        case 503:
          return const ResponseException(
            'Service unavailable. Please try again later.',
          );
        case 504:
          return const ResponseException('Request timeout. Please try again.');
        default:
          return ResponseException(
            'Server error: $code. Please try again later.',
          );
      }
    }

    // Unknown status codes
    return ResponseException('Unexpected response code: $code');
  }

  /// The user-friendly error message describing what went wrong.
  final String message;

  /// Returns a string representation of this exception.
  ///
  /// The format is: "ResponseException: [message]"
  @override
  String toString() {
    return 'ResponseException: $message';
  }
}
