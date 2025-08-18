import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/expiration.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class ExpirationInput extends StatelessWidget {
  const ExpirationInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.expiration;
        final curr = current.expiration;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final expiration = state.expiration;

        String? errorText;
        if (expiration.displayError == ExpirationValidationError.pastDate) {
          errorText = 'Expiration date cannot be in the past';
        }

        return DateTimePicker(
          key: const Key('inventoryCreate_expirationInput_datePicker'),
          labelText: 'Expiration Date',
          mode: DateTimePickerMode.date,
          onChanged: (date) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.expirationChanged(expiration: date),
            );
          },
          helperText: 'Optional',
          errorText: errorText,
        );
      },
    );
  }
}
