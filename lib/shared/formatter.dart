import 'package:intl/intl.dart';

/// Formats a double value as Philippine peso currency with 2 decimal places
/// Example: 1234.5 -> "₱ 1,234.50"
String formatToPHP(double amount) {
  final phpFormatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱ ',
    decimalDigits: 2,
  );

  return phpFormatter.format(amount);
}

String formatNumber(double number) {
  if (number == number.toInt()) {
    return number.toInt().toString();
  } else {
    return number.toStringAsFixed(2);
  }
}

/// Formats a DateTime object to a readable string format.
String formatDate(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(dateTime);
}

String formatTime(DateTime dateTime) {
  final formatter = DateFormat('hh:mm a');
  return formatter.format(dateTime);
}
