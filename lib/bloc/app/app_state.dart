part of 'app_bloc.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial() = Initial;
  const factory AppState.authenticated({
    required User user,
  }) = Authenticated;
  const factory AppState.unauthenticating({
    required User user,
  }) = Unauthenticating;
  const factory AppState.unauthenticated({
    String? errorMessage,
  }) = Unauthenticated;
}
