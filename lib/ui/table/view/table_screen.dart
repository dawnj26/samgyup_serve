import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:table_repository/table_repository.dart' as t;

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Tables'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: StatusCard(
                title: 'Total tables',
                color: Colors.red.shade100,
                count: 20,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: TableStatusFilter(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                final table = t.Table(
                  id: 'table_$index',
                  number: index + 1,
                  capacity: (index % 4) + 2,
                  status:
                      t.TableStatus.values[index % t.TableStatus.values.length],
                );

                return TableTile(table: table);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (ctx) => const CreateTableBottomSheet(),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
