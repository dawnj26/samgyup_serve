part of 'app_bloc.dart';

@freezed
class AppState with _$AppState {
  const factory AppState.initial() = Initial;
  const factory AppState.authenticated({
    required User user,
  }) = Authenticated;
  const factory AppState.unauthenticated({
    String? errorMessage,
  }) = Unauthenticated;
}
