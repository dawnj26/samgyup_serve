import 'package:formz/formz.dart';

enum PerHeadValidationError {
  empty,
  tooLow,
  invalid
  ;

  String get message {
    switch (this) {
      case PerHeadValidationError.empty:
        return 'Serving size cannot be empty.';
      case PerHeadValidationError.tooLow:
        return 'Serving size must be greater than zero.';
      case PerHeadValidationError.invalid:
        return 'Serving size must be a valid number.';
    }
  }
}

class PerHead extends FormzInput<String, PerHeadValidationError> {
  const PerHead.pure([super.value = '']) : super.pure();
  const PerHead.dirty([super.value = '']) : super.dirty();

  @override
  PerHeadValidationError? validator(String? value) {
    final perHead = value ?? '';

    if (perHead.isEmpty) {
      return PerHeadValidationError.empty;
    }

    final parsed = double.tryParse(perHead);
    if (parsed == null) {
      return PerHeadValidationError.invalid;
    }

    if (parsed <= 0) {
      return PerHeadValidationError.tooLow;
    }

    return null;
  }
}
