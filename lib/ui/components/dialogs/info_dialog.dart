import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    required this.title,
    required this.message,
    super.key,
    this.onOk,
  });

  final String title;
  final String message;
  final void Function()? onOk;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onOk?.call();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
