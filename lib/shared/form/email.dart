import 'package:formz/formz.dart';

enum EmailValidationError {
  empty,
  invalid,
}

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String? value) {
    final email = value ?? '';

    if (email.isEmpty) {
      return EmailValidationError.empty;
    }

    if (!_emailRegExp.hasMatch(email)) {
      return EmailValidationError.invalid;
    }

    return null;
  }
}
