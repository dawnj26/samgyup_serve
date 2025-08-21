import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class ExpirationInput extends StatelessWidget {
  const ExpirationInput({
    super.key,
    this.errorText,
    this.onChanged,
    this.initialValue,
  });

  final String? errorText;
  final ValueChanged<DateTime?>? onChanged;
  final DateTime? initialValue;

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      initialValue: initialValue,
      labelText: 'Expiration Date',
      mode: DateTimePickerMode.date,
      onChanged: onChanged,
      helperText: 'Optional',
      errorText: errorText,
    );
  }
}
