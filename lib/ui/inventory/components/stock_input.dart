import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/stock.dart';
import 'package:samgyup_serve/ui/components/outlined_text_field.dart';

class StockInput extends StatelessWidget {
  const StockInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.stock;
        final curr = current.stock;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final stock = state.stock;

        String? errorText;
        if (stock.displayError == StockValidationError.empty) {
          errorText = 'Stock is required';
        } else if (stock.displayError == StockValidationError.negative) {
          errorText = 'Stock cannot be negative';
        } else if (stock.displayError == StockValidationError.invalid) {
          errorText = 'Stock must be a valid number';
        }

        return OutlinedTextField(
          key: const Key('inventoryCreate_stockInput_textField'),
          labelText: 'Stock',
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.stockChanged(stock: value),
            );
          },
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.inventory_2_outlined),
          errorText: errorText,
        );
      },
    );
  }
}
