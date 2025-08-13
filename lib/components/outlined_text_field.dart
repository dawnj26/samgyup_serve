import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class OutlinedTextField extends StatelessWidget {
  const OutlinedTextField({
    this.labelText,
    super.key,
    this.onChanged,
    this.keyboardType,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,
  });

  final String? labelText;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return FTextField(
      onChange: onChanged,
      keyboardType: keyboardType,
      label: labelText != null ? Text(labelText ?? '') : null,
      hint: hintText,
      error: errorText != null ? Text(errorText ?? '') : null,
      obscureText: obscureText,
      suffixBuilder: suffixIcon != null
          ? (context, value, child) => suffixIcon!
          : null,
    );
  }
}
