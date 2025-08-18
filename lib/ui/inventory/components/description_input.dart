import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class DescriptionInput extends StatelessWidget {
  const DescriptionInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.description;
        final curr = current.description;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final description = state.description;

        String? errorText;
        if (description.displayError == DescriptionValidationError.tooLong) {
          errorText = 'Description must be at most 500 characters';
        }

        return OutlinedTextField(
          key: const Key('inventoryCreate_descriptionInput_textField'),
          labelText: 'Description',
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          minLines: 1,
          prefixIcon: const Icon(Icons.description_outlined),
          helperText: 'Optional',
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.descriptionChanged(description: value),
            );
          },
          errorText: errorText,
        );
      },
    );
  }
}
