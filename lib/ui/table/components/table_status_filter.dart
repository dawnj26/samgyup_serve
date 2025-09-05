import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:table_repository/table_repository.dart';

class TableStatusFilter extends StatefulWidget {
  const TableStatusFilter({super.key, this.onChanged, this.padding});

  final void Function(List<TableStatus> statuses)? onChanged;
  final EdgeInsetsGeometry? padding;

  @override
  State<TableStatusFilter> createState() => _TableStatusFilterState();
}

class _TableStatusFilterState extends State<TableStatusFilter> {
  List<TableStatus> _selectedStatuses = [];

  void _handleChange(TableStatus status, bool selected) {
    setState(() {
      if (!selected) {
        _selectedStatuses = _selectedStatuses
            .where((s) => s != status)
            .toList();
        return;
      }

      _selectedStatuses = [..._selectedStatuses, status];
    });

    widget.onChanged?.call(_selectedStatuses);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: widget.padding,
      child: Row(
        children: TableStatus.values.mapIndexed((i, status) {
          final isSelected = _selectedStatuses.contains(status);
          final rightPadding = i == TableStatus.values.length - 1 ? 0.0 : 8.0;

          return Padding(
            padding: EdgeInsets.only(right: rightPadding),
            child: FilterChip(
              label: Text(status.label),
              selected: isSelected,
              onSelected: (selected) => _handleChange(status, selected),
            ),
          );
        }).toList(),
      ),
    );
  }
}
