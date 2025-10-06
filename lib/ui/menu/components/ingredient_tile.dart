import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({
    required this.ingredient,
    super.key,
    this.trailing,
    this.inventoryItem,
  });

  final Ingredient ingredient;
  final InventoryItem? inventoryItem;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    var name = ingredient.name;

    final isSufficient =
        inventoryItem != null && inventoryItem!.stock > ingredient.quantity;
    if (!isSufficient) {
      name = '${ingredient.name} (Insufficient stock)';
    }

    log('inventoryItem: $inventoryItem', name: 'IngredientTile');

    return ListTile(
      tileColor: isSufficient ? null : Colors.red.withValues(alpha: 0.1),
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      title: Text(name),
      subtitle: Text(
        '${formatNumber(ingredient.quantity)} ${ingredient.unit.value}',
      ),
      trailing: trailing,
    );
  }
}
