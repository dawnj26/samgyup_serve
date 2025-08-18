import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';

class CategoryInput extends StatelessWidget {
  const CategoryInput({super.key});

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

    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.category;
        final curr = current.category;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final category = state.category;

        String? errorText;
        if (category.displayError == CategoryValidationError.empty) {
          errorText = 'Category is required';
        }

        return DropdownMenu<InventoryCategory>(
          key: const Key('inventoryCreate_categoryInput_dropdownMenu'),
          leadingIcon: const Icon(Icons.category_outlined),
          label: const Text('Category'),
          width: screenWidth - padding * 2,
          onSelected: (InventoryCategory? value) {
            if (value == null) return;

            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.categoryChanged(category: value),
            );
          },
          dropdownMenuEntries: entries,
          errorText: errorText,
        );
      },
    );
  }
}
