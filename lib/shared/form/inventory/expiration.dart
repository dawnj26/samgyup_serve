import 'package:formz/formz.dart';

enum ExpirationValidationError {
  pastDate,
}

class Expiration extends FormzInput<DateTime?, ExpirationValidationError> {
  const Expiration.pure() : super.pure(null);
  const Expiration.dirty([super.value]) : super.dirty();

  @override
  ExpirationValidationError? validator(DateTime? value) {
    final now = DateTime.now();
    if (value != null && value.isBefore(now)) {
      return ExpirationValidationError.pastDate;
    }

    return null;
  }
}
