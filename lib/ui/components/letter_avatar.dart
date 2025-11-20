import 'package:flutter/material.dart';

class LetterAvatar extends StatelessWidget {
  const LetterAvatar({
    required this.name,
    super.key,
    this.radius = 20.0,
    this.backgroundColor,
    this.foregroundColor,
  });
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      child: Text(initial),
    );
  }
}
