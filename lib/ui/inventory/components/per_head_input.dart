import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class PerHeadInput extends StatelessWidget {
  const PerHeadInput({
    super.key,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.initialValue,
  });

  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      initialValue: initialValue,
      labelText: 'Serving Size',
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.people_outline),
      onChanged: onChanged,
      errorText: errorText,
      enabled: enabled,
    );
  }
}
