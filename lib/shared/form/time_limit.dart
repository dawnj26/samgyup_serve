import 'package:formz/formz.dart';

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

RegExp _int = RegExp(r'^-?(?:0|[1-9][0-9]*)$');

class TimeLimit extends FormzInput<String, TimeLimitValidationError> {
  const TimeLimit.pure() : super.pure('');
  const TimeLimit.dirty([super.value = '']) : super.dirty();

  @override
  TimeLimitValidationError? validator(String value) {
    if (value.isEmpty) {
      return TimeLimitValidationError.empty;
    }

    if (!_int.hasMatch(value) || int.parse(value) <= 0) {
      return TimeLimitValidationError.invalid;
    }
    return null;
  }
}
