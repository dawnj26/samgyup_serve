import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';
part 'device.g.dart';

/// Represents a device in the system.
@freezed
abstract class Device with _$Device {
  /// Creates a [Device] with the given properties.
  const factory Device({
    /// Unique identifier for the device.
    required String id,

    /// Manufacturer of the device.
    required String manufacturer,

    /// Model name of the device.
    required String model,
  }) = _Device;

  const Device._();

  /// Creates a [Device] instance from a JSON map.
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// Returns the full name of the device combining manufacturer and model.
  String get name => '$manufacturer $model';
}
