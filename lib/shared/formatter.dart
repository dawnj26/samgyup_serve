import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _phpFormatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱ ',
    decimalDigits: 2,
  );

  /// Formats a double value as Philippine peso currency with 2 decimal places
  /// Example: 1234.5 -> "₱ 1,234.50"
  static String formatToPHP(double amount) {
    return _phpFormatter.format(amount);
  }
}

String formatNumber(double number) {
  if (number == number.toInt()) {
    return number.toInt().toString();
  } else {
    return number.toStringAsFixed(2);
  }
}

/// Formats a DateTime object to a readable string format.
String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}
