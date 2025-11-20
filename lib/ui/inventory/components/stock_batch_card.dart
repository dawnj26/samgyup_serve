import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/batch/delete/batch_delete_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/badge_indicator.dart';
import 'package:samgyup_serve/ui/inventory/components/batch_more_option_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class StockBatchCard extends StatelessWidget {
  const StockBatchCard({
    required this.batch,
    required this.unit,
    super.key,
  });

  final StockBatch batch;
  final MeasurementUnit unit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        title: Row(
          children: [
            Text(
              '${formatNumber(batch.quantity)} '
              '${unit.shorthand}',
              style: textTheme.bodyMedium,
            ),
            if (batch.expirationDate != null) ...[
              const SizedBox(width: 8),
              BadgeIndicator(
                color: Colors.orange,
                label: formatTimeRemaining(batch.expirationDate!),
              ),
            ],
          ],
        ),
        subtitle: Text(
          'Added ${timeago.format(batch.createdAt!)}',
          style: textTheme.bodySmall,
        ),
        trailing: BatchMoreOptionButton(
          onSelected: (option) {
            switch (option) {
              case BatchOption.remove:
                unawaited(
                  showConfirmationDialog(
                    context: context,
                    title: 'Remove Batch',
                    message:
                        'Are you sure you want to '
                        'remove this batch of stock?',
                    onConfirmed: () {
                      context.read<BatchDeleteBloc>().add(
                        BatchDeleteEvent.started(
                          batch: batch,
                        ),
                      );
                    },
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
