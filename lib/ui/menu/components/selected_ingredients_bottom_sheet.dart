import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class SelectedIngredientsBottomSheet extends StatelessWidget {
  const SelectedIngredientsBottomSheet({
    required this.ingredients,
    super.key,
    this.onRemove,
  });

  final List<Ingredient> ingredients;
  final void Function(Ingredient ingredient)? onRemove;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: screenHeight * 0.75,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.drag_handle_rounded)],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  child: Text(
                    'Ingredients',
                    style: textTheme.labelLarge,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: _IngredientList(
                    ingredients: ingredients,
                    onRemove: onRemove,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IngredientList extends StatefulWidget {
  const _IngredientList({
    required this.ingredients,
    required this.onRemove,
  });

  final List<Ingredient> ingredients;
  final void Function(Ingredient ingredient)? onRemove;

  @override
  State<_IngredientList> createState() => _IngredientListState();
}

class _IngredientListState extends State<_IngredientList> {
  late List<Ingredient> _i;

  @override
  void initState() {
    _i = widget.ingredients;
    super.initState();
  }

  void _handleRemove(Ingredient ingredient) {
    setState(() {
      _i = _i
          .where((e) => e.inventoryItemId != ingredient.inventoryItemId)
          .toList();
    });
    widget.onRemove?.call(ingredient);
  }

  @override
  Widget build(BuildContext context) {
    if (_i.isEmpty) {
      return const Center(
        child: Text('No ingredients selected.'),
      );
    }

    return ListView.builder(
      itemCount: _i.length,
      itemBuilder: (context, index) {
        final ingredient = _i[index];
        return IngredientTile(
          ingredient: ingredient,
          trailing: IconButton(
            onPressed: () => _handleRemove(ingredient),
            icon: const Icon(Icons.close_rounded),
          ),
        );
      },
    );
  }
}
