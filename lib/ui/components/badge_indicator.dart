import 'package:flutter/material.dart';

class BadgeIndicator extends StatelessWidget {
  const BadgeIndicator({required this.color, required this.label, super.key});

  final MaterialColor color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          color: color.shade50,
        ),
      ),
    );
  }
}
