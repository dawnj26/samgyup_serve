import 'package:auto_route/auto_route.dart';
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
        leading: IconButton(
          onPressed: () {
            context.router.back();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Inventory'),
        backgroundColor: colorTheme.primaryContainer,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              sliver: SliverToBoxAdapter(
                child: StatusSection(status: statuses),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
