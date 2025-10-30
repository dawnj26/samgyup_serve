import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class DetailDrawer extends StatelessWidget {
  const DetailDrawer({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = MaterialLocalizations.of(context);

    final tiles = <DrawerTileProps>[
      DrawerTileProps(
        title: 'Description',
        value: item.description == null || item.description!.isEmpty
            ? 'No description available'
            : item.description!,
      ),
      DrawerTileProps(
        title: 'Category',
        value: item.category.label,
      ),
      DrawerTileProps(
        title: 'Status',
        value: item.status.label,
      ),
      DrawerTileProps(
        title: 'Low Stock Threshold',
        value:
            '${item.lowStockThreshold.toStringAsFixed(0)} ${item.unit.value}',
      ),
      DrawerTileProps(
        title: 'Created At',
        value: locale.formatFullDate(item.createdAt),
      ),
    ];

    return NavigationDrawer(
      header: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.name,
                style: textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
      children: tiles.map((e) => _DrawerTile(props: e)).toList(),
    );
  }
}

class DrawerTileProps {
  const DrawerTileProps({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.props,
  });

  final DrawerTileProps props;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            props.title,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            props.value,
            style: textTheme.bodyLarge,
          ),
          const Divider(
            height: 24,
          ),
        ],
      ),
    );
  }
}
