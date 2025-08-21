import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/ui/components/buttons/primary_button.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<InventoryCreateBloc>().add(const InventoryCreateEvent.saved());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      builder: (context, state) {
        final isLoading = state is InventoryCreateLoading;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return PrimaryButton(
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
