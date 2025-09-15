part of 'app_bloc.dart';

@freezed
class AppEvent with _$AppEvent {
  const factory AppEvent.started() = _Started;
  const factory AppEvent.logout() = _Logout;
  const factory AppEvent.login({
    required User user,
  }) = _Login;
  const factory AppEvent.guestSessionStarted() = _GuestSessionStarted;
}
