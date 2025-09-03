import 'package:formz/formz.dart';

enum PriceValidationError {
  empty,
  negative,
  invalidFormat,
}

extension PriceValidationErrorX on PriceValidationError {
  String get message {
    switch (this) {
      case PriceValidationError.empty:
        return 'Price is required';
      case PriceValidationError.negative:
        return 'Price cannot be negative';
      case PriceValidationError.invalidFormat:
        return 'Price must be a valid number';
    }
  }
}

class Price extends FormzInput<String, PriceValidationError> {
  const Price.pure([super.value = '']) : super.pure();
  const Price.dirty([super.value = '']) : super.dirty();

  @override
  PriceValidationError? validator(String? value) {
    final priceString = value ?? '';

    if (priceString.isEmpty) {
      return PriceValidationError.empty;
    }

    final price = double.tryParse(priceString);
    if (price == null) {
      return PriceValidationError.invalidFormat;
    }

    if (price < 0) {
      return PriceValidationError.negative;
    }

    return null;
  }
}
