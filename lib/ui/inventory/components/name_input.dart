import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/name.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.name;
        final curr = current.name;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final name = state.name;

        String? errorText;
        if (name.displayError == NameValidationError.empty) {
          errorText = 'Item name is required';
        } else if (name.displayError == NameValidationError.tooShort) {
          errorText = 'Item name must be at least 3 characters';
        }

        return OutlinedTextField(
          key: const Key('inventoryCreate_nameInput_textField'),
          labelText: 'Item Name',
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.nameChanged(name: value),
            );
          },
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.label_outline),
          errorText: errorText,
          maxLength: 50,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                required maxLength,
              }) => null,
        );
      },
    );
  }
}
