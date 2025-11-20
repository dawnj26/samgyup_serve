part of 'user_form_bloc.dart';

@freezed
abstract class UserFormEvent with _$UserFormEvent {
  const factory UserFormEvent.nameChanged(String name) = _NameChanged;
  const factory UserFormEvent.emailChanged(String email) = _EmailChanged;
  const factory UserFormEvent.passwordChanged(String password) =
      _PasswordChanged;
  const factory UserFormEvent.submitted() = _Submitted;
}
