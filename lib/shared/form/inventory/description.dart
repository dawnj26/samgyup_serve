import 'package:formz/formz.dart';

enum DescriptionValidationError {
  tooLong,
}

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure() : super.pure('');
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
