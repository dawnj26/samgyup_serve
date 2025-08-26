import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';

class IngredientTile extends StatelessWidget {
  const IngredientTile({required this.ingredient, super.key, this.trailing});

  final Ingredient ingredient;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      title: Text(ingredient.name),
      subtitle: Text(
        '${formatNumber(ingredient.quantity)} ${ingredient.unit.value}',
      ),
      trailing: trailing,
    );
  }
}
