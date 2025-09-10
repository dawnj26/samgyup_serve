part of 'app_bloc.dart';

enum AppStatus { initial, loading, success, failure }

enum AuthStatus {
  authenticated,
  unauthenticated,
  authenticating,
  unauthenticating,
}

enum DeviceStatus { registered, unregistered, unknown }

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial({
    @Default(AppStatus.initial) AppStatus status,
    @Default(AuthStatus.unauthenticated) AuthStatus authStatus,
    @Default(DeviceStatus.unregistered) DeviceStatus deviceStatus,
    Device? device,
    User? user,
    String? errorMessage,
  }) = _Initial;
}
