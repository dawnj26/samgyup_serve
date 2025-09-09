import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/table/tables_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:samgyup_serve/ui/table/view/create/table_create_screen.dart';
import 'package:table_repository/table_repository.dart';

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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: _Total(),
            ),
          ),
          const SliverToBoxAdapter(
            child: TableStatusFilter(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: _TableList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (ctx) => TableCreateScreen(
              onCreated: () => _handleRefresh(context),
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }


class _TableList extends StatelessWidget {
  const _TableList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TablesBloc, TablesState>(
      builder: (context, state) {
        switch (state.status) {
          case TablesStatus.initial || TablesStatus.loading:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case TablesStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(state.errorMessage ?? 'Something went wrong!'),
              ),
            );
          case TablesStatus.success:
            final tables = state.tables;
            final hasReachedMax = state.hasReachedMax;

            if (tables.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyFallback(
                  message: 'No tables found.\nTap + to add a new table.',
                ),
              );
            }

            return SliverList.builder(
              itemCount: hasReachedMax ? tables.length : tables.length + 1,
              itemBuilder: (context, index) {
                if (index >= tables.length) {
                  return const BottomLoader();
                }

                final table = tables[index];
                return TableTile(table: table);
              },
            );
        }
      },
    );
  }
}

class _Total extends StatelessWidget {
  const _Total();

  @override
  Widget build(BuildContext context) {
    final total = context.select((TablesBloc bloc) => bloc.state.totalTables);

    return StatusCard(
      title: 'Total tables',
      color: Colors.red.shade100,
      count: total,
    );
  }
}
