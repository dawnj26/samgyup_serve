import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/item_tile.dart';

class InventoryItemList extends StatelessWidget {
  const InventoryItemList({
    required this.items,
    required this.hasReachedMax,
    super.key,
    this.onEdit,
    this.onTap,
  });

  final List<InventoryItem> items;
  final void Function(InventoryItem item)? onEdit;
  final void Function(InventoryItem item)? onTap;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (ctx, index) {
        return index >= items.length
            ? const BottomLoader()
            : ItemTile(
                item: items[index],
                onEdit: () => onEdit?.call(items[index]),
                onTap: () => onTap?.call(items[index]),
              );
      },
      itemCount: hasReachedMax ? items.length : items.length + 1,
    );
  }
}
