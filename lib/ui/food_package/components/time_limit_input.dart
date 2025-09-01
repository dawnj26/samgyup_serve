import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class TimeLimitInput extends StatelessWidget {
  const TimeLimitInput({
    super.key,
    this.initialValue,
    this.errorText,
    this.onChanged,
  });

  final String? initialValue;
  final String? errorText;
  final void Function(String timeLimit)? onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Time Limit (minutes)',
      keyboardType: TextInputType.number,
      initialValue: initialValue,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}
