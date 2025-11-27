import 'package:flutter/material.dart';
import 'package:log_repository/log_repository.dart';

class ActionFilters extends StatefulWidget {
  const ActionFilters({super.key, this.onActionSelected});

  final void Function(LogAction? action)? onActionSelected;

  @override
  State<ActionFilters> createState() => _ActionFiltersState();
}

class _ActionFiltersState extends State<ActionFilters> {
  LogAction? _selectedAction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: LogAction.values.map((action) {
        return FilterChip(
          label: Text(action.label),
          onSelected: (selected) {
            setState(() {
              _selectedAction = selected ? action : null;
            });

            widget.onActionSelected?.call(_selectedAction);
          },
          selected: _selectedAction == action,
        );
      }).toList(),
    );
  }
}
