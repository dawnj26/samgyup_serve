import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';

class CategoryInput extends StatelessWidget {
  const CategoryInput({
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
  });

  final MenuCategory? value;
  final String? errorText;
  final ValueChanged<MenuCategory?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final entries = MenuCategory.values
        .map(
          (category) => DropdownMenuEntry<MenuCategory>(
            value: category,
            label: category.label,
          ),
        )
        .toList();

    return DropdownMenu<MenuCategory>(
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
