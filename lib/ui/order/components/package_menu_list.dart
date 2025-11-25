import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/ui/inventory/components/inventory_list_item.dart';

class PackageMenuList extends StatelessWidget {
  const PackageMenuList({required this.menus, super.key});

  final List<InventoryItem> menus;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Text(
            'Included Menus',
            style: textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              itemBuilder: (context, index) {
                final menu = menus[index];
                return InventoryListItem(item: menu);
              },
              itemCount: menus.length,
            ),
          ),
        ),
      ],
    );
  }
}
