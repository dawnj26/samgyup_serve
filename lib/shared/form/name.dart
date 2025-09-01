import 'package:formz/formz.dart';

enum NameValidationError {
  empty,
  tooShort,
}

extension NameValidationErrorX on NameValidationError {
  String get message {
    switch (this) {
      case NameValidationError.empty:
        return 'Name is required';
      case NameValidationError.tooShort:
        return 'Name is too short';
    }
  }
}

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure([super.value = '']) : super.pure();
  const Name.dirty([super.value = '']) : super.dirty();

  static const int _minLength = 3;

  @override
  NameValidationError? validator(String? value) {
    final name = value ?? '';

    if (name.isEmpty) {
      return NameValidationError.empty;
    }

    if (name.length < _minLength) {
      return NameValidationError.tooShort;
    }

    return null;
  }
}
