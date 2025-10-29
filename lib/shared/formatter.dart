import 'package:intl/intl.dart';

/// Formats a double value as Philippine peso currency with 2 decimal places
/// Example: 1234.5 -> "₱ 1,234.50"
String formatToPHP(double amount, [int decimalDigits = 2]) {
  final phpFormatter = NumberFormat.currency(
    locale: 'en_PH',
    symbol: '₱ ',
    decimalDigits: decimalDigits,
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

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('yyyy-MM-dd hh:mm a');
  return formatter.format(dateTime);
}

/// Formats the time remaining until an expected date
/// Returns a human-readable string like "2 days left", "5 hours left", etc.
String formatTimeRemaining(
  DateTime expectedDate, {
  String dueText = 'Overdue',
}) {
  final now = DateTime.now();
  final difference = expectedDate.difference(now);

  if (difference.isNegative) {
    return dueText;
  }

  if (difference.inDays > 0) {
    final days = difference.inDays;
    return '$days ${days == 1 ? 'day' : 'days'} left';
  } else if (difference.inHours > 0) {
    final hours = difference.inHours;
    return '$hours ${hours == 1 ? 'hour' : 'hours'} left';
  } else if (difference.inMinutes > 0) {
    final minutes = difference.inMinutes;
    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} left';
  } else {
    return 'Just now';
  }
}
