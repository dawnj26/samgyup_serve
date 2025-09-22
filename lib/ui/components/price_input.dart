import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class PriceInput extends StatelessWidget {
  const PriceInput({
    super.key,
    this.onChanged,
    this.initialValue,
    this.errorText,
    this.labelText,
  });

  final void Function(String price)? onChanged;
  final String? initialValue;
  final String? errorText;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: labelText ?? 'Price',
      onChanged: onChanged,
      initialValue: initialValue,
      errorText: errorText,
      keyboardType: TextInputType.number,
    );
  }
}
