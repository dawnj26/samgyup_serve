import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/details/inventory_details_bloc.dart';
import 'package:samgyup_serve/data/enums/inventory_item_option.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventoryDetailsScreen extends StatelessWidget {
  const InventoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        actions: [
          Builder(
            builder: (context) {
              final item = context.select(
                (InventoryDetailsBloc bloc) => bloc.state.item,
              );

              return ItemMoreOptionButton(
                onSelected: (option) => _handleSelected(
                  context,
                  item,
                  option,
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: 16),
            Text(
              'Batches',
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: _BatchList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handlePressed(context),
        label: const Text('Add Stock'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _handleSelected(
    BuildContext context,
    InventoryItem item,
    InventoryItemOption option,
  ) {
    switch (option) {
      case InventoryItemOption.edit:
        unawaited(_handleEdit(item, context));
      case InventoryItemOption.delete:
        unawaited(
          showDialog<void>(
            context: context,
            builder: (ctx) => InventoryDeleteDialog(
              item: item,
              onDelete: () {
                context.read<InventoryDeleteBloc>().add(
                  InventoryDeleteEvent.started(
                    item: item,
                  ),
                );
              },
            ),
          ),
        );
    }
  }

  Future<void> _handleEdit(InventoryItem item, BuildContext context) async {
    final updatedItem = await context.router.push<InventoryItem>(
      InventoryEditRoute(
        item: item,
      ),
    );

    if (!context.mounted || updatedItem == null) return;

    context.read<InventoryDetailsBloc>().add(
      const InventoryDetailsEvent.batchRefreshed(),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(
      context.router.push(
        AddStockRoute(
          item: context.read<InventoryDetailsBloc>().state.item,
          onStockAdded: () {
            context.read<InventoryDetailsBloc>().add(
              const InventoryDetailsEvent.batchRefreshed(),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = context.select(
      (InventoryDetailsBloc bloc) => bloc.state.item,
    );

    final description = item.description ?? 'No description available.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: BucketImage(fileId: item.imageId),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(item.name, style: textTheme.titleLarge),
            const SizedBox(width: 8),
            BadgeIndicator(
              color: item.status.color,
              label: item.status.label,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined),
                const SizedBox(width: 8),
                Text(
                  '${formatNumber(item.getAvailableStock())} '
                  '${item.unit.shorthand}',
                ),
              ],
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded),
                const SizedBox(width: 8),
                Text(
                  '${formatNumber(item.lowStockThreshold)} '
                  '${item.unit.shorthand}',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Description', style: textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          description,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _BatchList extends StatelessWidget {
  const _BatchList();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<InventoryDetailsBloc, InventoryDetailsState>(
      builder: (context, state) {
        final item = state.item;
        final status = state.status;

        if (status == LoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (status == LoadingStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong.',
              style: textTheme.bodyMedium,
            ),
          );
        }

        if (item.stockBatches.isEmpty) {
          return Center(
            child: Text(
              'No stock batches available.',
              style: textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          itemCount: item.stockBatches.length,
          itemBuilder: (context, index) {
            final batch = item.stockBatches[index];

            return StockBatchCard(batch: batch, unit: item.unit);
          },
        );
      },
    );
  }
}
