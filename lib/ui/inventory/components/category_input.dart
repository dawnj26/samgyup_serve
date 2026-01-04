import 'package:flutter/material.dart';

class CategoryInput extends StatelessWidget {
  const CategoryInput({
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
    this.categories = const [],
  });

  final String? value;
  final String? errorText;
  final ValueChanged<String?>? onSelected;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final entries = categories
        .map(
          (category) => DropdownMenuEntry<String>(
            value: category,
            label: category,
          ),
        )
        .toList();

    return DropdownMenu<String>(
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
