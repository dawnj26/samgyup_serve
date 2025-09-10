/// Exception thrown when a device is not supported by the application.
class DeviceNotSupported implements Exception {
  /// Creates a [DeviceNotSupported] exception with an optional error message.
  DeviceNotSupported([this.message = 'Device not supported']);

  /// The error message describing why the device is not supported.
  final String message;

  @override
  String toString() => 'DeviceNotSupported: $message';
}
