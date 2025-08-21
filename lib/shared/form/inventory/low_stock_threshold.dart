import 'package:formz/formz.dart';

enum LowStockThresholdValidationError {
  empty,
  negative,
  invalid,
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
