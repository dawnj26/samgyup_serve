import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class QuantityDialog extends StatefulWidget {
  const QuantityDialog({
    required this.initialValue,
    super.key,
    this.title,
    this.maxValue,
  });

  final String? title;
  final int initialValue;
  final int? maxValue;

  @override
  State<QuantityDialog> createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'Set Quantity'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityInput(
            controller: _controller,
            initialValue: widget.initialValue,
            maxValue: widget.maxValue ?? 999,
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            widget.maxValue != null
                ? 'Max: ${widget.maxValue}'
                : 'Set quantity',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final quantity = int.tryParse(_controller.text);
            if (quantity != null) {
              Navigator.of(context).pop(quantity);
            }

            setState(() {
              _errorText = 'Please enter a valid quantity';
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
