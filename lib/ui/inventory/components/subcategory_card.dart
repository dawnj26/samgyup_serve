import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

/// A card widget that displays subcategory information with a delete action.
class SubcategoryCard extends StatelessWidget {
  /// Creates a [SubcategoryCard].
  const SubcategoryCard({
    required this.subcategory,
    this.onDelete,
    this.onTap,
    super.key,
  });

  /// The subcategory to display.
  final Subcategory subcategory;

  /// Callback when delete button is pressed.
  final VoidCallback? onDelete;

  /// Callback when card is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon representing subcategory
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.category_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Subcategory name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subcategory.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subcategory.parent.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              color: theme.colorScheme.error,
              tooltip: 'Delete subcategory',
            ),
          ],
        ),
      ),
    );
  }
}
