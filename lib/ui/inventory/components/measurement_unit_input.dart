import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart';

class MeasurementUnitInput extends StatelessWidget {
  const MeasurementUnitInput({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final menuHeight = screenHeight * 0.4;

    final entries = i.MeasurementUnit.values
        .map(
          (unit) => DropdownMenuEntry<i.MeasurementUnit>(
            value: unit,
            label: unit.value,
          ),
        )
        .toList();

    const padding = 16.0;

    return BlocBuilder<InventoryCreateBloc, InventoryCreateState>(
      buildWhen: (previous, current) {
        final prev = previous.measurementUnit;
        final curr = current.measurementUnit;

        return prev.value != curr.value || prev.isPure != curr.isPure;
      },
      builder: (context, state) {
        final measurementUnit = state.measurementUnit;
        String? errorText;
        if (measurementUnit.displayError ==
            MeasurementUnitValidationError.empty) {
          errorText = 'Measurement unit is required';
        }

        return DropdownMenu<i.MeasurementUnit>(
          key: const Key('inventoryCreate_measurementUnitInput_dropdownMenu'),
          leadingIcon: const Icon(Icons.straighten_outlined),
          menuHeight: menuHeight,
          label: const Text('Unit'),
          width: screenWidth - padding * 2,
          onSelected: (i.MeasurementUnit? value) {
            if (value == null) return;

            context.read<InventoryCreateBloc>().add(
              InventoryCreateEvent.unitChanged(
                measurementUnit: value,
              ),
            );
          },
          dropdownMenuEntries: entries,
          errorText: errorText,
        );
      },
    );
  }
}
