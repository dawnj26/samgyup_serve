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
      child: ListTile(
        title: Row(
          children: [
            Text(
              'Table ${table.number}',
              style: textTheme.titleMedium,
            ),
            const SizedBox(width: 8),
            TableStatusBadge(status: table.status),
          ],
        ),
        subtitle: Text('Capacity: ${table.capacity}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onTap?.call(table),
      ),
    );
  }
}
