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
