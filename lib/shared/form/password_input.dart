import 'package:formz/formz.dart';

enum PasswordInputValidationError {
  empty,
  tooShort
  ;

  String get message => switch (this) {
    PasswordInputValidationError.empty => 'Password cannot be empty.',
    PasswordInputValidationError.tooShort =>
      'Password must be at least 8 characters long.',
  };
}

class PasswordInput extends FormzInput<String, PasswordInputValidationError> {
  const PasswordInput.pure() : super.pure('');
  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordInputValidationError? validator(String? value) {
    final email = value ?? '';

    if (email.isEmpty) {
      return PasswordInputValidationError.empty;
    }

    if (email.length < 8) {
      return PasswordInputValidationError.tooShort;
    }

    return null;
  }
}
