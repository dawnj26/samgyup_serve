import 'package:flutter/material.dart';

enum PackageMoreOption {
  edit,
  delete,
}

extension PackageMoreOptionX on PackageMoreOption {
  String get label {
    switch (this) {
      case PackageMoreOption.edit:
        return 'Edit';
      case PackageMoreOption.delete:
        return 'Delete';
    }
  }

  IconData get icon {
    switch (this) {
      case PackageMoreOption.edit:
        return Icons.edit;
      case PackageMoreOption.delete:
        return Icons.delete;
    }
  }
}

class PackageMoreOptionButton extends StatelessWidget {
  const PackageMoreOptionButton({super.key, this.onSelected, this.style});

  final void Function(PackageMoreOption option)? onSelected;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PackageMoreOption>(
      style: style,
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => PackageMoreOption.values
          .map(
            (option) => PopupMenuItem<PackageMoreOption>(
              value: option,
              child: ListTile(
                leading: Icon(option.icon),
                title: Text(option.label),
              ),
            ),
          )
          .toList(),
    );
  }
}
