import 'package:flutter/material.dart';

class SavePackageButton extends StatelessWidget {
  const SavePackageButton({
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.onPressed,
  });

  final EdgeInsetsGeometry padding;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: FilledButton(
        onPressed: onPressed,
        child: const Text('Save'),
      ),
    );
  }
}
