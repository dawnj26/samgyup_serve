import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class TransactionRefInput extends StatelessWidget {
  const TransactionRefInput({super.key, this.errorText, this.onChanged});

  final String? errorText;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedTextField(
      labelText: 'Transaction Reference',
      errorText: errorText,
      onChanged: onChanged,
      helperText: 'Optional',
    );
  }
}
