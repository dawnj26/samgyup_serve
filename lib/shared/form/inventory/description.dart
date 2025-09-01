import 'package:formz/formz.dart';

enum DescriptionValidationError {
  tooLong,
}

extension DescriptionValidationErrorX on DescriptionValidationError {
  String get message {
    switch (this) {
      case DescriptionValidationError.tooLong:
        return 'Description is too long';
    }
  }
}

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure([super.value = '']) : super.pure();
  const Description.dirty([super.value = '']) : super.dirty();

  static const int _maxLength = 200;

  @override
  DescriptionValidationError? validator(String? value) {
    final description = value ?? '';

    if (description.length > _maxLength) {
      return DescriptionValidationError.tooLong;
    }

    return null;
  }
}
