import 'package:flutter/material.dart';
import 'package:order_repository/order_repository.dart';

import 'package:samgyup_serve/ui/order/components/order_status_badge.dart';

class OrderStatusDropdown extends StatelessWidget {
  const OrderStatusDropdown({
    required this.currentStatus,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final OrderStatus currentStatus;
  final ValueChanged<OrderStatus> onChanged;
  final bool enabled;

  Future<void> _showStatusDialog(BuildContext context) async {
    final result = await showDialog<OrderStatus>(
      context: context,
      builder: (context) => _OrderStatusDialog(currentStatus: currentStatus),
    );

    if (result != null && result != currentStatus) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _showStatusDialog(context) : null,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OrderStatusBadge(status: currentStatus),
          if (enabled) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: currentStatus.color,
              size: 20,
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderStatusDialog extends StatelessWidget {
  const _OrderStatusDialog({required this.currentStatus});

  final OrderStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Change Order Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...OrderStatus.values.map((status) {
              final isSelected = status == currentStatus;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(status),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? status.color.withValues(alpha: 0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? status.color
                            : Colors.grey.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        OrderStatusBadge(status: status),
                        const Spacer(),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: status.color,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
