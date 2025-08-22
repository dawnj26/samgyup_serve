import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/data/enums/inventory_item_option.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/delete_dialog.dart';
import 'package:samgyup_serve/ui/inventory/components/item_more_option_button.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({required this.item, super.key, this.onEdit, this.onTap});

  final InventoryItem item;
  final void Function()? onEdit;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              overflow: TextOverflow.fade,
            ),
          ),
          const SizedBox(width: 8),
          BadgeIndicator(
            color: item.status.color,
            label: item.status.label,
          ),
        ],
      ),
      subtitle: Text(
        // Description of the item, including stock and category.
        // ignore: lines_longer_than_80_chars
        '${item.stock.toStringAsFixed(0)} ${item.unit.value} · ${item.category.label}',
      ),
      trailing: ItemMoreOptionButton(
        onSelected: (option) {
          switch (option) {
            case InventoryItemOption.edit:
              onEdit?.call();
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
      onTap: onTap,
    );
  }
}
