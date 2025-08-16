import 'package:flutter/material.dart';
import 'package:samgyup_serve/components/components.dart';
import 'package:samgyup_serve/data/models/inventory_status.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

    final statuses = InventoryStatus(
      all: InventoryStatusItem(
        title: 'All',
        count: 100,
        color: colorTheme.primaryContainer,
      ),
      inStock: InventoryStatusItem(
        title: 'In Stock',
        count: 75,
        color: colorTheme.secondaryContainer,
      ),
      lowStock: InventoryStatusItem(
        title: 'Low Stock',
        count: 15,
        color: colorTheme.errorContainer,
      ),
      outOfStock: InventoryStatusItem(
        title: 'Out of Stock',
        count: 10,
        color: colorTheme.tertiaryContainer,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: colorTheme.primaryContainer,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatusCard(
                          status: statuses.all,
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: StatusCard(status: statuses.inStock),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StatusCard(status: statuses.lowStock),
                      ),
                      Expanded(
                        child: StatusCard(status: statuses.outOfStock),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
