import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({
    required this.menuInfo,
    required this.isLoading,
    super.key,
  });

  final MenuInfo menuInfo;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          StatusCard(
            title: 'Total Items',
            color: Colors.blue.shade100,
            count: isLoading ? null : menuInfo.totalItems,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatusCard(
                  title: 'Available',
                  color: Colors.green.shade100,
                  count: isLoading ? null : menuInfo.availableItems,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatusCard(
                  title: 'Unavailable',
                  color: Colors.red.shade100,
                  count: isLoading ? null : menuInfo.unavailableItems,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
