import 'package:formz/formz.dart';

enum PriceValidationError {
  empty,
  negative,
  invalidFormat,
}

class Price extends FormzInput<String, PriceValidationError> {
  const Price.pure() : super.pure('');
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
