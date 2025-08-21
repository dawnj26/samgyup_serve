import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';
import 'package:samgyup_serve/data/models/inventory_status.dart';
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
                    status: InventoryStatusItem(
                      title: 'All',
                      count: isLoading ? null : inventoryInfo.totalItems,
                      color: Colors.blue.shade100,
                    ),
                    onTap: () => _handleNavigation(context),
                  ),
                ),
                Expanded(
                  child: StatusCard(
                    status: InventoryStatusItem(
                      title: 'In Stock',
                      count: isLoading ? null : inventoryInfo.inStockItems,
                      color: InventoryItemStatus.inStock.color,
                    ),
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.inStock,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    status: InventoryStatusItem(
                      title: 'Low Stock',
                      count: isLoading ? null : inventoryInfo.lowStockItems,
                      color: InventoryItemStatus.lowStock.color,
                    ),
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.lowStock,
                    ),
                  ),
                ),
                Expanded(
                  child: StatusCard(
                    status: InventoryStatusItem(
                      title: 'Out of Stock',
                      count: isLoading ? null : inventoryInfo.outOfStockItems,
                      color: InventoryItemStatus.outOfStock.color,
                    ),
                    onTap: () => _handleNavigation(
                      context,
                      InventoryItemStatus.outOfStock,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StatusCard(
                    status: InventoryStatusItem(
                      title: 'Expired',
                      count: isLoading ? null : inventoryInfo.expiredItems,
                      color: InventoryItemStatus.expired.color,
                    ),
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
