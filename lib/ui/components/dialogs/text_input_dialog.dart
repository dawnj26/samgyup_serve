import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  const TextInputDialog({
    required this.title,
    super.key,
    this.initialValue,
    this.validator,
  });

  final String title;
  final String? initialValue;
  final String? Function(String)? validator;

  @override
  State<TextInputDialog> createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  late final TextEditingController _controller;
  String? _errorMessage;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_validateInput)
      ..dispose();
    super.dispose();
  }

  void _validateInput() {
    if (widget.validator != null && _hasInteracted) {
      setState(() {
        _errorMessage = widget.validator!(_controller.text.trim());
      });
    }
  }

  void _onTextFieldChanged() {
    if (!_hasInteracted) {
      setState(() {
        _hasInteracted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        onChanged: (_) => _onTextFieldChanged(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: _errorMessage,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _errorMessage != null
              ? null
              : () => Navigator.of(context).pop(_controller.text.trim()),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
