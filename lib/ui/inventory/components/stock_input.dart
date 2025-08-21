import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/outlined_text_field.dart';

class StockInput extends StatelessWidget {
  const StockInput({
    super.key,
    this.errorText,
    this.onChanged,
  });

  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Stock',
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      prefixIcon: const Icon(Icons.inventory_2_outlined),
      errorText: errorText,
    );
  }
}
