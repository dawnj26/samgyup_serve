import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:settings_repository/src/enums/enums.dart';

part 'setting.freezed.dart';
part 'setting.g.dart';

/// Represents a configuration setting with a name, value, and type.
@freezed
abstract class Setting with _$Setting {
  /// Creates a new [Setting] instance.
  ///
  /// The [name] identifies the setting, [value] holds its current value,
  /// and [type] defines how the value should be interpreted.
  const factory Setting({
    /// The unique name/key of the setting.
    required String name,

    /// The type of the value (string, integer, or boolean).
    required SettingValueType type,

    /// A user-friendly title for the setting.
    required String title,

    /// The unique identifier for this setting.
    @Default('') String id,

    /// The setting's value stored as a string.
    String? value,

    /// Optional description of what this setting does.
    String? description,

    /// When this setting was created.
    DateTime? createdAt,

    /// When this setting was last updated.
    DateTime? updatedAt,
  }) = _Setting;

  /// Creates an empty [Setting] with default values.
  factory Setting.empty() => const _Setting(
    name: '',
    value: '',
    type: SettingValueType.string,
    title: '',
  );

  /// Creates a [Setting] instance from a JSON map.
  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
}
