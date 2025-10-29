import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:timeago/timeago.dart' as timeago;

class ItemTile extends StatelessWidget {
  const ItemTile({
    required this.item,
    super.key,
    this.onTap,
    this.trailing,
    this.onAdd,
  });

  final InventoryItem item;
  final void Function()? onTap;
  final void Function(InventoryItem item)? onAdd;
  final Widget? trailing;

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
        '${timeago.format(item.createdAt)} · ${item.totalStock.toStringAsFixed(0)} ${item.unit.value}',
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
