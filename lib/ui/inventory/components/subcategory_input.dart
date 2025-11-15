import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class SubcategoryInput extends StatelessWidget {
  const SubcategoryInput({
    required this.subcategories,
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
    this.enabled = true,
    this.controller,
  });

  final List<Subcategory> subcategories;
  final Subcategory? value;
  final String? errorText;
  final ValueChanged<Subcategory?>? onSelected;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final entries = subcategories
        .map(
          (subcategory) => DropdownMenuEntry<Subcategory>(
            value: subcategory,
            label: subcategory.name,
          ),
        )
        .toList();

    return DropdownMenu<Subcategory>(
      key: const Key('inventoryCreate_subcategoryInput_dropdownMenu'),
      leadingIcon: const Icon(Icons.list_outlined),
      label: const Text('Subcategory'),
      width: screenWidth - padding * 2,
      initialSelection: value,
      controller: controller,
      onSelected: enabled ? onSelected : null,
      dropdownMenuEntries: entries,
      errorText: errorText,
      enabled: enabled,
    );
  }
}
