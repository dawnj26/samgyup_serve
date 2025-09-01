import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class HomeStatus extends StatelessWidget {
  const HomeStatus({super.key, this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StatusCard(
      title: 'Total packages',
      color: colorScheme.primaryContainer,
      count: count,
    );
  }
}
