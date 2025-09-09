import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/table/delete/table_delete_bloc.dart';
import 'package:samgyup_serve/bloc/table/details/table_details_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:samgyup_serve/ui/table/view/form/table_form_screen.dart';

class TableDetailsScreen extends StatelessWidget {
  const TableDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TableMoreOptionButton(
            onSelected: (option) => _handleSelected(context, option),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _Header(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _CurrentReservationHeader(),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Center(
                child: Text(
                  'Reservations will be shown here when there are any.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSelected(
    BuildContext context,
    TableMoreOption option,
  ) async {
    final table = context.read<TableDetailsBloc>().state.table;

    switch (option) {
      case TableMoreOption.edit:
        await showModalBottomSheet<void>(
          isScrollControlled: true,
          context: context,
          builder: (ctx) => TableFormScreen(
            initialTable: table,
            onSaved: () {
              context.read<TableDetailsBloc>().add(
                const TableDetailsEvent.changed(),
              );
            },
          ),
        );
      case TableMoreOption.delete:
        final delete = await showDeleteDialog(
          context: context,
          message:
              'Are you sure you want to delete this table? '
              'This action cannot be undone.',
        );

        if (!context.mounted || !delete) return;

        context.read<TableDeleteBloc>().add(
          TableDeleteEvent.started(id: table.id),
        );
      case TableMoreOption.assign:
        break;
    }
  }
}

class _CurrentReservationHeader extends StatelessWidget {
  const _CurrentReservationHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Current reservation',
          style: textTheme.titleMedium,
        ),
        TextButton(
          onPressed: () {},
          child: const Text('View all'),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final table = context.select((TableDetailsBloc bloc) => bloc.state.table);
    final isAssigned = table.deviceId != null && table.deviceId!.isNotEmpty;

    final deviceStatus = isAssigned
        ? 'Assigned to ${table.deviceId}'
        : 'Not assigned to any device';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Table ${table.number}',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TableCapacity(capacity: table.capacity),
            const SizedBox(width: 16),
            TableStatusBadge(status: table.status),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          deviceStatus,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
