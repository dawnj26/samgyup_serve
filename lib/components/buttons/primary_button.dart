import 'package:flutter/material.dart';
import 'package:forui/widgets/button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.child, super.key, this.onPressed});

  final void Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FButton(
      onPress: onPressed,
      child: child,
    );
  }
}
