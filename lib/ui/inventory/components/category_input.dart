import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class CategoryInput extends StatelessWidget {
  const CategoryInput({
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
  });

  final InventoryCategory? value;
  final String? errorText;
  final ValueChanged<InventoryCategory?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final entries = InventoryCategory.values
        .map(
          (category) => DropdownMenuEntry<InventoryCategory>(
            value: category,
            label: category.label,
          ),
        )
        .toList();

    return DropdownMenu<InventoryCategory>(
      key: const Key('inventoryCreate_categoryInput_dropdownMenu'),
      leadingIcon: const Icon(Icons.category_outlined),
      label: const Text('Category'),
      width: screenWidth - padding * 2,
      initialSelection: value,
      onSelected: onSelected,
      dropdownMenuEntries: entries,
      errorText: errorText,
    );
  }
}
