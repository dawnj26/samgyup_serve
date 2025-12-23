import 'package:flutter/material.dart';

enum BatchOption {
  remove
  ;

  String get label {
    switch (this) {
      case BatchOption.remove:
        return 'Remove';
    }
  }
}

class BatchMoreOptionButton extends StatelessWidget {
  const BatchMoreOptionButton({super.key, this.onSelected});

  final void Function(BatchOption option)? onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<BatchOption>(
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) {
        return BatchOption.values.map((option) {
          return PopupMenuItem<BatchOption>(
            value: option,
            child: Text(option.label),
          );
        }).toList();
      },
    );
  }
}
