import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/table/tables_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:samgyup_serve/ui/table/view/form/table_form_screen.dart';
import 'package:table_repository/table_repository.dart';
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: InfiniteScrollLayout(
            onLoadMore: () => _handleLoadMore(context),
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: _Total(),
                ),
              ),
              SliverToBoxAdapter(
                child: TableStatusFilter(
                  onChanged: (statuses) =>
                      _handleStatusChanged(context, statuses),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: _TableList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Table'),
        onPressed: () => _handlePressed(context),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (ctx) => TableFormScreen(
          onSaved: () => _handleRefresh(context),
        ),
        isScrollControlled: true,
      ),
    );
  }

  void _handleLoadMore(BuildContext context) {
    context.read<TablesBloc>().add(const TablesEvent.loadedMore());
  }

  void _handleStatusChanged(BuildContext context, List<TableStatus> statuses) {
    context.read<TablesBloc>().add(TablesEvent.statusChanged(statuses));
  }

  void _handleRefresh(BuildContext context) {
    context.read<TablesBloc>().add(const TablesEvent.refreshed());
  }
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

            if (tables.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyFallback(
                  message: 'No tables found.\nTap + to add a new table.',
                ),
              );
            }

            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: kIsWeb ? 4 : 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 3 / 2,
              ),
              itemCount: tables.length,
              itemBuilder: (context, index) {
                final table = tables[index];
                return TableTile(
                  table: table,
                  onTap: (table) => _handleTap(context, table),
                );
              },
            );
        }
      },
    );
  }

  void _handleTap(BuildContext context, t.Table table) {
    unawaited(
      context.router.push(
        TableDetailsRoute(
          id: table.id,
          table: table,
          onChanged: () => _handleRefresh(context),
        ),
      ),
    );
  }

  void _handleRefresh(BuildContext context) {
    context.read<TablesBloc>().add(const TablesEvent.refreshed());
  }
}

class _Total extends StatelessWidget {
  const _Total();

  @override
  Widget build(BuildContext context) {
    final total = context.select((TablesBloc bloc) => bloc.state.totalTables);

    return StatusCard(
      title: 'Total tables',
      color: Colors.red.shade700,
      count: total,
    );
  }
}
