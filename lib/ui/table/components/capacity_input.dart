import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class CapacityInput extends StatelessWidget {
  const CapacityInput({
    super.key,
    this.initialValue,
    this.errorText,
    this.onChanged,
  });

  final String? initialValue;
  final String? errorText;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Capacity',
      keyboardType: TextInputType.number,
      initialValue: initialValue,
      errorText: errorText,
      onChanged: onChanged,
    );
  }
}
