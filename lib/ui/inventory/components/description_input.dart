import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({
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
      labelText: 'Description',
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      minLines: 1,
      prefixIcon: const Icon(Icons.description_outlined),
      helperText: 'Optional',
      onChanged: onChanged,
      errorText: errorText,
    );
  }
}
