part of 'app_bloc.dart';

@freezed
abstract class AppEvent with _$AppEvent {
  const factory AppEvent.started() = _Started;
  const factory AppEvent.checkDevice() = _CheckDevice;
  const factory AppEvent.logout() = _Logout;
  const factory AppEvent.login({
    required User user,
  }) = _Login;
  const factory AppEvent.guestSessionStarted() = _GuestSessionStarted;
  const factory AppEvent.settingsChanged({
    required Settings settings,
  }) = _SettingsChanged;
}
