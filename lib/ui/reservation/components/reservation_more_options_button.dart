import 'package:flutter/material.dart';

enum ReservationMoreOptionsButtonType {
  cancel;

  String get label {
    switch (this) {
      case ReservationMoreOptionsButtonType.cancel:
        return 'Cancel';
    }
  }
}

class ReservationMoreOptionsButton extends StatelessWidget {
  const ReservationMoreOptionsButton({super.key, this.onSelected});

  final void Function(ReservationMoreOptionsButtonType option)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ReservationMoreOptionsButtonType>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => ReservationMoreOptionsButtonType.values
          .map(
            (option) => PopupMenuItem<ReservationMoreOptionsButtonType>(
              value: option,
              child: Text(option.label),
            ),
          )
          .toList(),
    );
  }
}
