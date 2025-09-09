import 'package:flutter/material.dart';
import 'package:table_repository/table_repository.dart';

class TableStatusBadge extends StatelessWidget {
  const TableStatusBadge({required this.status, super.key});

  final TableStatus status;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final color = switch (status) {
      TableStatus.available => Colors.green,
      TableStatus.occupied => Colors.red,
      TableStatus.outOfService => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
