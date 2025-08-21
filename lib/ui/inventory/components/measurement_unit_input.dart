import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;

class MeasurementUnitInput extends StatelessWidget {
  const MeasurementUnitInput({
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
  });

  final i.MeasurementUnit? value;
  final String? errorText;
  final ValueChanged<i.MeasurementUnit?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final menuHeight = screenHeight * 0.4;
    const padding = 16.0;

    final entries = i.MeasurementUnit.values
        .map(
          (unit) => DropdownMenuEntry<i.MeasurementUnit>(
            value: unit,
            label: unit.value,
          ),
        )
        .toList();

    return DropdownMenu<i.MeasurementUnit>(
      leadingIcon: const Icon(Icons.straighten_outlined),
      menuHeight: menuHeight,
      label: const Text('Unit'),
      width: screenWidth - padding * 2,
      initialSelection: value,
      onSelected: onSelected,
      dropdownMenuEntries: entries,
      errorText: errorText,
    );
  }
}
