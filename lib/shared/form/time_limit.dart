import 'package:formz/formz.dart';
import 'package:string_validator/string_validator.dart';

enum TimeLimitValidationError { empty, invalid }

extension TimeLimitValidationErrorX on TimeLimitValidationError {
  String get message {
    switch (this) {
      case TimeLimitValidationError.empty:
        return 'Time limit is required';
      case TimeLimitValidationError.invalid:
        return 'Time limit must be a positive integer';
    }
  }
}

class TimeLimit extends FormzInput<String, TimeLimitValidationError> {
  const TimeLimit.pure([super.value = '']) : super.pure();
  const TimeLimit.dirty([super.value = '']) : super.dirty();

  @override
  TimeLimitValidationError? validator(String value) {
    if (value.isEmpty) {
      return TimeLimitValidationError.empty;
    }

    if (!value.isInt || int.parse(value) <= 0) {
      return TimeLimitValidationError.invalid;
    }
    return null;
  }
}
