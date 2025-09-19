import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/reservation/components/components.dart';

class ReservationBillingScreen extends StatelessWidget {
  const ReservationBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Billing'),
      ),
      body: const ReservationOrderList(),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: _Button(),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    final total = context.select(
      (ReservationBloc bloc) => bloc.state.invoice.totalAmount,
    );
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount:',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            Text(formatToPHP(total), style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () async {
            final confirm = await showConfirmationDialog(
              context: context,
              title: 'Confirm Payment',
              message:
                  'Are you sure you want to finish your '
                  'order and proceed with the payment?',
            );

            if (!context.mounted || !confirm) return;

            final state = context.read<ReservationBloc>().state;

            context.read<HomeBloc>().add(
              HomeEvent.paymentRequested(
                invoiceId: state.invoice.id,
              ),
            );
            context.read<EventBloc>().add(
              EventEvent.paymentRequested(
                reservationId: state.reservation.id,
                tableNumber: state.table.number,
                invoiceId: state.invoice.id,
              ),
            );
          },
          child: const Text('Proceed to Payment'),
        ),
      ],
    );
  }
}
