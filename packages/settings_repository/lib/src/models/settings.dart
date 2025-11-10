import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

/// Represents the application settings configuration.
///
/// This model contains business-related settings
/// such as name, logo, and QR code.
@freezed
abstract class Settings with _$Settings {
  /// Creates a new Settings instance.
  ///
  /// The [id] is required to uniquely identify the settings.
  /// [businessName] defaults to 'Samgyup Serve' if not provided.
  /// [businessLogo] and [qrCode] are optional.
  factory Settings({
    @Default('settings') String id,
    @Default('Samgyup Serve') String businessName,
    String? businessLogo,
    String? qrCode,
  }) = _Settings;

  /// Creates a Settings instance from a JSON map.
  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  /// Creates a Settings instance with default values.
  factory Settings.empty() => Settings();
}
