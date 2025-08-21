import 'package:formz/formz.dart';

enum LowStockThresholdValidationError {
  empty,
  negative,
  invalid,
  tooHigh,
}

class LowStockThreshold
    extends FormzInput<String, LowStockThresholdValidationError> {
  const LowStockThreshold.pure([super.value = '', this.stock = -1])
    : super.pure();
  const LowStockThreshold.dirty(this.stock, [super.value = '']) : super.dirty();

  final double stock;

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

    if (parsedValue > stock) {
      return LowStockThresholdValidationError.tooHigh;
    }
    return null;
  }
}
