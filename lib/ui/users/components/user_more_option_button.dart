import 'package:flutter/material.dart';

enum UserOption { delete, update }

class UserMoreOptionButton extends StatelessWidget {
  const UserMoreOptionButton({
    super.key,
    this.onSelected,
  });
  final void Function(UserOption)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UserOption>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<UserOption>>[
        const PopupMenuItem<UserOption>(
          value: UserOption.update,
          child: Text('Update'),
        ),
        const PopupMenuItem<UserOption>(
          value: UserOption.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
