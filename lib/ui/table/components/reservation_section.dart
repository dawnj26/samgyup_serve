import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/reservation/components/reservation_order_list.dart';

class ReservationSection extends StatelessWidget {
  const ReservationSection({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReservationBloc(
            billingRepository: context.read(),
            reservationRepository: context.read(),
            tableRepository: context.read(),
          )..add(ReservationEvent.started(reservationId: reservationId)),
        ),
        BlocProvider(
          create: (context) => OrderListBloc(
            orderRepository: context.read(),
            packageRepository: context.read(),
            menuRepository: context.read(),
          ),
        ),
      ],
      child: BlocListener<ReservationBloc, ReservationState>(
        listener: (context, state) {
          if (state.status == ReservationStatus.success) {
            context.read<OrderListBloc>().add(
              OrderListEvent.started(orderIds: state.invoice.orderIds),
            );
          }
        },
        child: const _Main(),
      ),
    );
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ReservationBloc, ReservationState>(
      builder: (context, state) {
        if (state.status == ReservationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.invoice.code,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Status: ${state.invoice.status.label}'),
                  Text('Total: ${formatToPHP(state.invoice.totalAmount)}'),
                  const SizedBox(height: 16),
                  Text('Orders', style: textTheme.titleMedium),
                ],
              ),
            ),
            const Expanded(child: ReservationOrderList()),
          ],
        );
      },
    );
  }
}
