import 'package:flutter/material.dart';

class TableCapacity extends StatelessWidget {
  const TableCapacity({required this.capacity, super.key});

  final int capacity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_rounded),
        const SizedBox(width: 4),
        Text('$capacity'),
      ],
    );
  }
}
