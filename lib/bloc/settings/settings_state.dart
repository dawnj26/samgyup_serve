part of 'settings_bloc.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState.initial({
    required Settings settings,
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
