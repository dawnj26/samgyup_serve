part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, success, failure }

enum SettingUpdateStatus { initial, loading, success, failure }

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState.initial({
    @Default(SettingsStatus.initial) SettingsStatus status,
    @Default(SettingUpdateStatus.initial) SettingUpdateStatus updateStatus,
    @Default([]) List<Setting> settings,
    String? errorMessage,
  }) = _Initial;
}
