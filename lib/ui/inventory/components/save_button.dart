import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/edit/inventory_edit_bloc.dart';
import 'package:samgyup_serve/ui/components/buttons/primary_button.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<InventoryEditBloc>().add(const InventoryEditEvent.saved());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryEditBloc, InventoryEditState>(
      builder: (context, state) {
        final isLoading = state is InventoryEditLoading;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return PrimaryButton(
          key: const Key('inventoryEditScreen_saveButton'),
          onPressed: !isLoading ? () => _onPressed(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Save'),
              if (isLoading) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
