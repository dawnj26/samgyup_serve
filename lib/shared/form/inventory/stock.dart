import 'package:formz/formz.dart';

enum StockValidationError {
  empty,
  invalid,
  negative
  ;

  String get message {
    switch (this) {
      case StockValidationError.empty:
        return 'Stock cannot be empty.';
      case StockValidationError.invalid:
        return 'Stock must be a valid number.';
      case StockValidationError.negative:
        return 'Stock cannot be negative.';
    }
  }
}

class Stock extends FormzInput<String, StockValidationError> {
  const Stock.pure([super.value = '']) : super.pure();
  const Stock.dirty([super.value = '']) : super.dirty();

  @override
  StockValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return StockValidationError.empty;
    }

    final parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return StockValidationError.invalid;
    }

    if (parsedValue < 0) {
      return StockValidationError.negative;
    }

    return null;
  }
}
