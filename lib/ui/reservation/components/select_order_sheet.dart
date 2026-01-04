import 'package:flutter/material.dart';

enum OrderType {
  item,
  package,
}

class SelectOrderSheet extends StatelessWidget {
  const SelectOrderSheet({required this.onSelectItem, super.key});

  static Future<OrderType?> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<OrderType>(
      context: context,
      builder: (context) => SelectOrderSheet(
        onSelectItem: (type) {
          Navigator.of(context).pop(type);
        },
      ),
    );
  }

  final void Function(OrderType type) onSelectItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.fastfood),
          title: const Text('Add Item'),
          onTap: () => onSelectItem(OrderType.item),
        ),
        ListTile(
          leading: const Icon(Icons.card_giftcard),
          title: const Text('Add Package'),
          onTap: () => onSelectItem(OrderType.package),
        ),
      ],
    );
  }
}
