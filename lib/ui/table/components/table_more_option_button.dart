import 'package:flutter/material.dart';

enum TableMoreOption {
  assign,
  edit,
  delete,
}

extension TableMoreOptionX on TableMoreOption {
  String get label {
    switch (this) {
      case TableMoreOption.edit:
        return 'Edit';
      case TableMoreOption.delete:
        return 'Delete';
      case TableMoreOption.assign:
        return 'Assign to device';
    }
  }
}

class TableMoreOptionButton extends StatelessWidget {
  const TableMoreOptionButton({super.key, this.onSelected});

  final void Function(TableMoreOption option)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TableMoreOption>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => TableMoreOption.values
          .map(
            (option) => PopupMenuItem<TableMoreOption>(
              value: option,
              child: Text(option.label),
            ),
          )
          .toList(),
    );
  }
}
