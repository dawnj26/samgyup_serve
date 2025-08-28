import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class AvailableBadge extends StatelessWidget {
  const AvailableBadge({required this.isAvailable, super.key});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final color = isAvailable ? Colors.green : Colors.red;
    final label = isAvailable ? 'Available' : 'Not Available';

    return BadgeIndicator(color: color, label: label);
  }
}
