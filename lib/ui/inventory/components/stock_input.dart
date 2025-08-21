import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/outlined_text_field.dart';

class StockInput extends StatelessWidget {
  const StockInput({
    super.key,
    this.errorText,
    this.onChanged,
    this.initialValue,
  });

  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      initialValue: initialValue,
      labelText: 'Stock',
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.inventory_2_outlined),
      errorText: errorText,
    );
  }
}
