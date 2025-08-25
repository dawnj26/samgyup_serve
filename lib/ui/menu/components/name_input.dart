import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    super.key,
    this.onChanged,
    this.initialValue,
    this.errorText,
  });

  final void Function(String name)? onChanged;
  final String? initialValue;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Name',
      onChanged: onChanged,
      initialValue: initialValue,
      errorText: errorText,
    );
  }
}
