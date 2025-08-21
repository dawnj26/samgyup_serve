import 'package:flutter/material.dart';
import 'package:samgyup_serve/data/models/inventory_status.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({
    required this.status,
    this.onTap,
    super.key,
  });

  final InventoryStatusItem status;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      color: status.color,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status.title,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                status.count?.toString() ?? '-',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
