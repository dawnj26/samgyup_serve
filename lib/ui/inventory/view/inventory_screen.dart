import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/data/models/inventory_status.dart';
import 'package:samgyup_serve/ui/inventory/components/category_card.dart';
import 'package:samgyup_serve/ui/inventory/components/status_section.dart';

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
            sliver: SliverToBoxAdapter(child: StatusSection(status: statuses)),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  // Placeholder for inventory items
                  return ListTile(
                    title: Text('Inventory Item $index'),
                    subtitle: Text('Details about item $index'),
                    leading: const Icon(Icons.inventory),
                    onTap: () {
                      // Handle item tap
                    },
                  );
                },
                childCount: 20, // Example item count
              ),
            ),
          ),
        ],
      ),
    );
  }
}
