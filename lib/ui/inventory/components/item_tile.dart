import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/data/enums/inventory_item_option.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/inventory/components/delete_dialog.dart';
import 'package:samgyup_serve/ui/inventory/components/item_more_option_button.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      title: Text(item.name),
      subtitle: Text(
        // Description of the item, including stock and category.
        // ignore: lines_longer_than_80_chars
        '${item.stock.toStringAsFixed(0)} ${item.unit.value} · ${item.category.label}',
      ),
      trailing: ItemMoreOptionButton(
        onSelected: (option) {
          switch (option) {
            case InventoryItemOption.edit:
              context.router.push(InventoryEditRoute(item: item));
            case InventoryItemOption.delete:
              showDialog<void>(
                context: context,
                builder: (ctx) => DeleteDialog(
                  item: item,
                  onDelete: () {
                    context.read<InventoryDeleteBloc>().add(
                      InventoryDeleteEvent.started(item: item),
                    );
                  },
                ),
              );
          }
        },
      ),
      onTap: () {
        // TODO(item): Implement item tap action
      },
    );
  }
}
