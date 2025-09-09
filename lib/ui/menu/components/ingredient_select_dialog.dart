import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';

class IngredientSelectDialog extends StatefulWidget {
  const IngredientSelectDialog({required this.item, super.key});

  final InventoryItem item;

  @override
  State<IngredientSelectDialog> createState() => _IngredientSelectDialogState();
}

class _IngredientSelectDialogState extends State<IngredientSelectDialog> {
  final _textController = TextEditingController();
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.item.name),
      content: TextField(
        autofocus: true,
        controller: _textController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Quantity',
          errorText: _errorText,
          suffixText: widget.item.unit.shorthand,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final quantity = _validateInput(_textController.text);
            if (quantity == null) return;

            final item = widget.item;

            final ingredient = Ingredient(
              name: item.name,
              quantity: quantity,
              unit: item.unit,
              createdAt: DateTime.now(),
              menuItemId: '',
              inventoryItemId: item.id,
            );

            Navigator.of(context).pop(ingredient);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  double? _validateInput(String input) {
    final value = double.tryParse(input);
    if (value == null || value <= 0) {
      setState(() {
        _errorText = 'Please enter a valid positive number';
      });
      return null;
    }
    setState(() {
      _errorText = null;
    });
    return value;
  }
}
