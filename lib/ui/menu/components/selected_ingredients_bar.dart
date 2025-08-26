import 'package:flutter/material.dart';

class SelectedIngredientsBar extends StatelessWidget {
  const SelectedIngredientsBar({required this.count, super.key, this.onView});

  final int count;
  final void Function()? onView;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        color: colorScheme.surfaceContainer,
        padding: const EdgeInsets.only(
          left: 16,
          right: 8,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$count ingredients selected',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onView,
              child: const Text('View'),
            ),
          ],
        ),
      ),
    );
  }
}
