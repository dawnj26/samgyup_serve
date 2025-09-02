import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class InventoryDeleteDialog extends StatelessWidget {
  const InventoryDeleteDialog({required this.item, super.key, this.onDelete});

  final InventoryItem item;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: Text('Do you want to delete ${item.name}?'),
      actions: [
        TextButton(
          onPressed: () {
            context.router.pop();
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            context.router.pop();
            onDelete?.call();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
