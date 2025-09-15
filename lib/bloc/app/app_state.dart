part of 'app_bloc.dart';

enum AppStatus { initial, loading, success, failure }

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  unauthenticating,
  guest,
}

enum DeviceStatus { registered, unregistered, unknown }

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial({
    @Default(AppStatus.initial) AppStatus status,
    @Default(AuthStatus.initial) AuthStatus authStatus,
    @Default(DeviceStatus.unregistered) DeviceStatus deviceStatus,
    DeviceData? deviceData,
    User? user,
    String? errorMessage,
  }) = _Initial;
}
