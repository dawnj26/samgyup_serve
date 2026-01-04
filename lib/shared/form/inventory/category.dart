import 'package:formz/formz.dart';

enum CategoryValidationError {
  empty,
}

class Category extends FormzInput<String?, CategoryValidationError> {
  const Category.pure([super.value]) : super.pure();
  const Category.dirty([super.value]) : super.dirty();

  @override
  CategoryValidationError? validator(String? value) {
    if (value == null) {
      return CategoryValidationError.empty;
    }

    return null;
  }
}
