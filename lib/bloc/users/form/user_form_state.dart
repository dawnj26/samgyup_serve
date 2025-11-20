part of 'user_form_bloc.dart';

@freezed
abstract class UserFormState with _$UserFormState {
  const factory UserFormState.initial({
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(Name.pure()) Name name,
    @Default(Email.pure()) Email email,
    @Default(PasswordInput.pure()) PasswordInput password,
    String? errorMessage,
  }) = _Initial;
}
