import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class StatusSection extends StatelessWidget {
  const StatusSection({super.key});

  Future<void> _handleNavigation(
    BuildContext context, [
    InventoryItemStatus? status,
  ]) async {
    final triggerReload =
        (await context.router.push<bool>(
          InventoryStatusListRoute(status: status),
        )) ??
        false;
    if (!context.mounted || !triggerReload) return;

    context.read<InventoryBloc>().add(
      const InventoryEvent.reload(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      builder: (context, state) {
        final isLoading = state is InventoryInitial;
        final inventoryInfo = state.inventoryInfo;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    title: 'All',
                    color: Colors.blue.shade100,
                    count: isLoading ? null : inventoryInfo.totalItems,
                    onTap: () => _handleNavigation(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatusCard(
                    title: 'In Stock',
                    color: InventoryItemStatus.inStock.color.shade100,
                    count: isLoading ? null : inventoryInfo.inStockItems,
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.inStock,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    title: 'Low Stock',
                    color: InventoryItemStatus.lowStock.color.shade100,
                    count: isLoading ? null : inventoryInfo.lowStockItems,
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.lowStock,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: StatusCard(
                    title: 'Out of Stock',
                    color: InventoryItemStatus.outOfStock.color.shade100,
                    count: isLoading ? null : inventoryInfo.outOfStockItems,
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.outOfStock,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    title: 'Expired',
                    color: InventoryItemStatus.expired.color.shade200,
                    count: isLoading ? null : inventoryInfo.expiredItems,
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.expired,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
