import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class LowStockThresholdInput extends StatelessWidget {
  const LowStockThresholdInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      builder: (context, state) {
        final lowStockThreshold = state.lowStockThreshold;
        final enabled = state.stock.isValid;

        String? errorText;
        if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.empty) {
          errorText = 'Low stock threshold is required';
        } else if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.negative) {
          errorText = 'Low stock threshold cannot be negative';
        } else if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.tooHigh) {
          errorText = 'Low stock threshold must be less than or equal to stock';
        } else if (lowStockThreshold.displayError ==
            LowStockThresholdValidationError.invalid) {
          errorText = 'Low stock threshold must be a valid number';
        }

        return OutlinedTextField(
          key: const Key('inventoryCreate_lowStockThresholdInput_textField'),
          labelText: 'Low Stock Threshold',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.warning_amber_outlined),
          onChanged: (value) {
            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.lowStockThresholdChanged(
                lowStockThreshold: value,
              ),
            );
          },
          errorText: errorText,
          enabled: enabled,
        );
      },
    );
  }
}
