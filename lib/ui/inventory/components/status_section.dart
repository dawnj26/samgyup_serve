import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/models/inventory_status.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({required this.status, super.key});

  final InventoryStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatusCard(
                status: status.all,
                onTap: () {},
              ),
            ),
            Expanded(
              child: StatusCard(status: status.inStock),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: StatusCard(status: status.lowStock),
            ),
            Expanded(
              child: StatusCard(status: status.outOfStock),
            ),
          ],
        ),
      ],
    );
  }
}
