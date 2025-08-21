import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/enums/inventory_item_option.dart';

class ItemMoreOptionButton extends StatelessWidget {
  const ItemMoreOptionButton({super.key, this.onSelected});

  final void Function(InventoryItemOption option)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<InventoryItemOption>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) =>
          InventoryItemOption.values.map((InventoryItemOption option) {
            return PopupMenuItem<InventoryItemOption>(
              value: option,
              child: Text(option.label),
            );
          }).toList(),
      onSelected: onSelected,
    );
  }
}
