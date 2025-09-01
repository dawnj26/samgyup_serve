import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({
    super.key,
    this.onChanged,
    this.initialValue,
    this.errorText,
  });

  final void Function(String description)? onChanged;
  final String? initialValue;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Description',
      onChanged: onChanged,
      initialValue: initialValue,
      errorText: errorText,
      maxLines: 5,
      minLines: 1,
    );
  }
}
