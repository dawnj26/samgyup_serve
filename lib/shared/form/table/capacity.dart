import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum CapacityValidationError { empty, invalid, tooSmall }

extension CapacityValidationErrorX on CapacityValidationError {
  String get message {
    switch (this) {
      case CapacityValidationError.empty:
        return 'Capacity is required.';
      case CapacityValidationError.invalid:
        return 'Capacity must be a valid number.';
      case CapacityValidationError.tooSmall:
        return 'Capacity must be at least 1.';
    }
  }
}

class Capacity extends FormzInput<String, CapacityValidationError> {
  const Capacity.pure([super.value = '']) : super.pure();
  const Capacity.dirty([super.value = '']) : super.dirty();

  @override
  CapacityValidationError? validator(String value) {
    if (value.isEmpty) {
      return CapacityValidationError.empty;
    }

    if (!value.isInt) {
      return CapacityValidationError.invalid;
    }

    final capacity = int.parse(value);
    if (capacity < 1) {
      return CapacityValidationError.tooSmall;
    }

    return null;
  }
}
