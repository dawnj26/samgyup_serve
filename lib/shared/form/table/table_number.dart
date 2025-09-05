import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum TableNumberValidationError { invalid, empty }

extension TableNumberValidationErrorX on TableNumberValidationError {
  String get message {
    switch (this) {
      case TableNumberValidationError.invalid:
        return 'Table number must be a valid number.';
      case TableNumberValidationError.empty:
        return 'Table number is required.';
    }
  }
}

class TableNumber extends FormzInput<String, TableNumberValidationError> {
  const TableNumber.pure([super.value = '']) : super.pure();
  const TableNumber.dirty([super.value = '']) : super.dirty();

  @override
  TableNumberValidationError? validator(String value) {
    if (value.isEmpty) {
      return TableNumberValidationError.empty;
    }

    if (!value.isInt) {
      return TableNumberValidationError.invalid;
    }

    return null;
  }
}
