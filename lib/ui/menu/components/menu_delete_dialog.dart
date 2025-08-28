import 'package:flutter/material.dart';

class MenuDeleteDialog extends StatelessWidget {
  const MenuDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Menu Item'),
      content: const Text(
        'Are you sure you want to delete this menu item? '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
