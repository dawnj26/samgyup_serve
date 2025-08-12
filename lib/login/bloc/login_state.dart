part of 'login_bloc.dart';

@freezed
abstract class LoginState with _$LoginState {
  const factory LoginState.initial({
    @Default(Email.pure()) Email email,
    @Default(Password.pure()) Password password,
    @Default(true) bool isValid,
  }) = LoginInitial;
  const factory LoginState.dirty({
    required Email email,
    required Password password,
    required bool isValid,
  }) = LoginDirty;
  const factory LoginState.loading({
    required Email email,
    required Password password,
    required bool isValid,
  }) = LoginLoading;
  const factory LoginState.failure({
    required Email email,
    required Password password,
    required String message,
    required bool isValid,
  }) = LoginFailure;
  const factory LoginState.success({
    required Email email,
    required Password password,
    required bool isValid,
    required User user,
  }) = LoginSuccess;
}
