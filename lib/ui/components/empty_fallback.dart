import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class EmptyFallback extends StatelessWidget {
  const EmptyFallback({
    required this.message,
    super.key,
    this.padding = EdgeInsets.zero,
  });

  final String message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: padding,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(12),
          stackFit: StackFit.expand,
          dashPattern: [10, 5],
          strokeWidth: 2,
          color: colorScheme.outlineVariant,
        ),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
