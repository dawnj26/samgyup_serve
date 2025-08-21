import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class LowStockThresholdInput extends StatelessWidget {
  const LowStockThresholdInput({
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
      labelText: 'Low Stock Threshold',
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.warning_amber_outlined),
      onChanged: onChanged,
      errorText: errorText,
      enabled: enabled,
    );
  }
}
