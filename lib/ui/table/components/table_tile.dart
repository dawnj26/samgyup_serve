import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:table_repository/table_repository.dart' as t;

class TableTile extends StatelessWidget {
  const TableTile({required this.table, super.key, this.onTap});

  final t.Table table;
  final void Function(t.Table table)? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onTap?.call(table),
        child: GridTile(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table ${table.number}',
                  style: textTheme.titleMedium,
                ),
                Text(
                  'Capacity: ${table.capacity}',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                TableStatusBadge(status: table.status),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
