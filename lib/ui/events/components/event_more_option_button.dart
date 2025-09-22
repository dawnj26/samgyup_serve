import 'package:flutter/material.dart';

enum EventMoreOption {
  markAsDone;

  String get label {
    switch (this) {
      case EventMoreOption.markAsDone:
        return 'Mark as Done';
    }
  }
}

class EventMoreOptionButton extends StatelessWidget {
  const EventMoreOptionButton({super.key, this.onSelected});

  final void Function(EventMoreOption option)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<EventMoreOption>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) => EventMoreOption.values
          .map(
            (option) => PopupMenuItem<EventMoreOption>(
              value: option,
              child: Text(option.label),
            ),
          )
          .toList(),
    );
  }
}
