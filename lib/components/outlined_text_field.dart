import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    this.labelText,
    super.key,
    this.onChanged,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
  });

  final String? labelText;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: errorText,
        suffixIcon: suffixIcon,
      ),
      obscureText: obscureText,
    );
  }
}
