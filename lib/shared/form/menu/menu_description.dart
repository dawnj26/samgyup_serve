import 'package:formz/formz.dart';

enum MenuDescriptionValidationError {
  tooLong,
  empty,
}

class MenuDescription
    extends FormzInput<String, MenuDescriptionValidationError> {
  const MenuDescription.pure([super.value = '']) : super.pure();
  const MenuDescription.dirty([super.value = '']) : super.dirty();

  static const int _maxLength = 200;

  @override
  MenuDescriptionValidationError? validator(String? value) {
    final description = value ?? '';

    if (description.length > _maxLength) {
      return MenuDescriptionValidationError.tooLong;
    }

    if (description.isEmpty) {
      return MenuDescriptionValidationError.empty;
    }

    return null;
  }
}
