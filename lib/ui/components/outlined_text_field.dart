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
    this.prefixIcon,
    this.maxLines = 1,
    this.minLines,
    this.hintText,
    this.helperText,
    this.maxLength,
    this.buildCounter,
    this.enabled,
    this.initialValue,
  });

  final String? labelText;
  final void Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final String? helperText;
  final int? maxLength;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  buildCounter;
  final bool? enabled;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        errorText: errorText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        hintText: hintText,
        helperText: helperText,
      ),
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      buildCounter: buildCounter,
      enabled: enabled,
    );
  }
}
