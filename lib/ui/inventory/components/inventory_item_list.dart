import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/data/enums/inventory_item_option.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

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
    if (items.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text('No items found.'),
        ),
      );
    }

    return SliverList.builder(
      itemBuilder: (ctx, index) {
        return index >= items.length
            ? const BottomLoader()
            : ItemTile(
                item: items[index],
                onTap: () => onTap?.call(items[index]),
                trailing: ItemMoreOptionButton(
                  onSelected: (option) => _handleSelected(
                    context,
                    items[index],
                    option,
                  ),
                ),
              );
      },
      itemCount: hasReachedMax ? items.length : items.length + 1,
    );
  }

  void _handleSelected(
    BuildContext context,
    InventoryItem item,
    InventoryItemOption option,
  ) {
    switch (option) {
      case InventoryItemOption.edit:
        onEdit?.call(item);
      case InventoryItemOption.delete:
        unawaited(
          showDialog<void>(
            context: context,
            builder: (ctx) => InventoryDeleteDialog(
              item: item,
              onDelete: () {
                context.read<InventoryDeleteBloc>().add(
                  InventoryDeleteEvent.started(
                    item: item,
                  ),
                );
              },
            ),
          ),
        );
    }
  }
}
