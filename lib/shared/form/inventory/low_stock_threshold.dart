import 'package:formz/formz.dart';

enum LowStockThresholdValidationError {
  empty,
  negative,
  invalid;

  String get message {
    switch (this) {
      case LowStockThresholdValidationError.empty:
        return 'Low stock threshold cannot be empty.';
      case LowStockThresholdValidationError.invalid:
        return 'Low stock threshold must be a valid number.';
      case LowStockThresholdValidationError.negative:
        return 'Low stock threshold cannot be negative.';
    }
  }
}

class LowStockThreshold
    extends FormzInput<String, LowStockThresholdValidationError> {
  const LowStockThreshold.pure([super.value = '']) : super.pure();
  const LowStockThreshold.dirty([super.value = '']) : super.dirty();

  @override
  LowStockThresholdValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return LowStockThresholdValidationError.empty;
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return LowStockThresholdValidationError.invalid;
    }
    if (parsedValue < 0) {
      return LowStockThresholdValidationError.negative;
    }

    return null;
  }
}
