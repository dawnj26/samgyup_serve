import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.message,
    this.onConfirmed,
    this.onCancelled,
  });

  final String? title;
  final String? message;
  final void Function()? onConfirmed;
  final void Function()? onCancelled;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Are you sure?'),
      content: Text(message ?? 'This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancelled?.call();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirmed?.call();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
