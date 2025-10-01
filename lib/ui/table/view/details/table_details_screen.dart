import 'package:auto_route/auto_route.dart';
import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/table/delete/table_delete_bloc.dart';
import 'package:samgyup_serve/bloc/table/details/table_details_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:samgyup_serve/ui/table/view/form/table_form_screen.dart';
import 'package:table_repository/table_repository.dart' as t;

class TableDetailsScreen extends StatelessWidget {
  const TableDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TableMoreOptionButton(
            onSelected: (option) => _handleSelected(context, option),
          ),
        ],
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: _Header(),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: _CurrentReservationHeader(),
          ),
          Expanded(child: _Reservation()),
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
        final router = context.router.parent<StackRouter>();

        await router?.push(
          DeviceSelectRoute(
            onSelected: (device) =>
                _handleDeviceSelect(context, device, router, table),
          ),
        );
    }
  }

  Future<void> _handleDeviceSelect(
    BuildContext ctx,
    Device device,
    StackRouter? router,
    t.Table table,
  ) async {
    if (device.tableId == table.id) {
      await router?.maybePop();
      return;
    }

    if (device.tableId != null) {
      final assigned = await showConfirmationDialog(
        context: ctx,
        title: 'Device already assigned',
        message:
            'This device is already assigned to another table. '
            'Are you sure you want to reassign it to this table?',
      );

      if (!assigned) return;
    }
    await router?.maybePop();

    if (!ctx.mounted) return;

    ctx.read<TableDetailsBloc>().add(
      TableDetailsEvent.assigned(device),
    );
  }
}

class _Reservation extends StatelessWidget {
  const _Reservation();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final reservationId = context.select(
      (TableDetailsBloc bloc) => bloc.state.reservationId,
    );

    if (reservationId != null) {
      return ReservationSection(reservationId: reservationId);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Center(
        child: Text(
          'No current reservation',
          style: textTheme.bodyMedium,
        ),
      ),
    );
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
        // TextButton(
        //   onPressed: () {},
        //   child: const Text('View all'),
        // ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final table = context.select((TableDetailsBloc bloc) => bloc.state.table);
    final device = context.select((TableDetailsBloc bloc) => bloc.state.device);
    final status = context.select(
      (TableDetailsBloc bloc) => bloc.state.status,
    );

    final isLoading =
        status == TableDetailsStatus.loading ||
        status == TableDetailsStatus.initial;
    final textTheme = Theme.of(context).textTheme;

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
        const SizedBox(height: 16),
        if (device == null)
          Text(
            isLoading ? 'Loading device...' : 'No device assigned',
            style: textTheme.bodyMedium,
          )
        else
          DeviceChip(
            device: device,
            onRemoved: () => _handleRemoveDevice(context),
          ),
      ],
    );
  }

  Future<void> _handleRemoveDevice(BuildContext context) async {
    final confirmed = await showConfirmationDialog(
      context: context,
      title: 'Remove device',
      message: 'Are you sure you want to remove the device from this table?',
    );

    if (!confirmed || !context.mounted) return;

    final device = context.read<TableDetailsBloc>().state.device;
    if (device == null) return;

    context.read<TableDetailsBloc>().add(
      TableDetailsEvent.unassigned(device),
    );
  }
}
