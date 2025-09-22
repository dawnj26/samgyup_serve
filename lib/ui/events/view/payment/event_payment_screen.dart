import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/invoice/invoice_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/events/components/components.dart';
import 'package:samgyup_serve/ui/reservation/components/components.dart';

class EventPaymentScreen extends StatelessWidget {
  const EventPaymentScreen({required this.event, super.key});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(event.type.label),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table #${event.tableNumber}',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Created at: ${formatTime(event.createdAt!.toLocal())}',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const Expanded(child: _Invoice()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {
            unawaited(
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => PaymentBottomSheet(
                  totalAmount: context
                      .read<InvoiceBloc>()
                      .state
                      .invoices
                      .totalAmount,
                  onSuccess: (payment) {
                    context.read<InvoiceBloc>().add(
                      InvoiceEvent.paid(payment: payment),
                    );
                  },
                ),
              ),
            );
          },
          child: const Text('Pay'),
        ),
      ),
    );
  }
}

class _Invoice extends StatelessWidget {
  const _Invoice();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        switch (state.status) {
          case InvoiceBlocStatus.initial || InvoiceBlocStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case InvoiceBlocStatus.failure:
            return const Center(child: Text('Failed to load invoice'));
          case InvoiceBlocStatus.success:
            final invoice = state.invoices;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.code,
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total amount: ${formatToPHP(invoice.totalAmount)}',
                        style: textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const Expanded(child: ReservationOrderList()),
              ],
            );
        }
      },
    );
  }
}
