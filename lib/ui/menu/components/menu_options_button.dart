import 'package:flutter/material.dart';

enum MenuOptions { edit, delete }

class MenuOptionsButton extends StatelessWidget {
  const MenuOptionsButton({required this.onSelected, super.key, this.style});

  final void Function(MenuOptions option) onSelected;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      icon: const Icon(Icons.more_vert),
      style: style,
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: MenuOptions.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem(
          value: MenuOptions.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
