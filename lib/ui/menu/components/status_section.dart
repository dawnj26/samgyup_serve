import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: StatusCard(
              title: 'Available',
              color: Colors.green.shade100,
              count: 42,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: StatusCard(
              title: 'Unavailable',
              color: Colors.red.shade100,
              count: 8,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
