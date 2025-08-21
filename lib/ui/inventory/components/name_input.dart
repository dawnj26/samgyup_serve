import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    super.key,
    this.initialValue,
    this.onNameChanged,
    this.errorText,
  });

  final String? initialValue;
  final String? errorText;
  final void Function(String name)? onNameChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      initialValue: initialValue,
      labelText: 'Item Name',
      onChanged: onNameChanged,
      keyboardType: TextInputType.text,
      prefixIcon: const Icon(Icons.label_outline),
      errorText: errorText,
      maxLength: 50,
      buildCounter:
          (
            context, {
            required currentLength,
            required isFocused,
            required maxLength,
          }) => null,
    );
  }
}
