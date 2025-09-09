import 'package:flutter/material.dart';
import 'package:table_repository/table_repository.dart';

class TableStatusDropdownMenu extends StatelessWidget {
  const TableStatusDropdownMenu({
    super.key,
    this.value,
    this.errorText,
    this.onSelected,
  });

  final TableStatus? value;
  final String? errorText;
  final ValueChanged<TableStatus?>? onSelected;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const padding = 16.0;
    final options = TableStatus.values
        .map(
          (status) => DropdownMenuEntry<TableStatus>(
            value: status,
            label: status.label,
          ),
        )
        .toList();

    return DropdownMenu<TableStatus>(
      initialSelection: value,
      label: const Text('Status'),
      dropdownMenuEntries: options,
      width: screenWidth - padding * 2,
      onSelected: onSelected,
      errorText: errorText,
    );
  }
}
