import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';
import 'package:samgyup_serve/ui/reservation/components/components.dart';

class ReservationOrderScreen extends StatelessWidget {
  const ReservationOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        scrolledUnderElevation: 0,
        leading: const AppLogoIcon(
          padding: EdgeInsetsGeometry.all(8),
        ),
        title: const Text('Reservation Order'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: ReservationHeader(),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: _OrdersHeader(
              onTap: () {
                context.router.push(MenuSelectRoute(initialItems: const []));
              },
            ),
          ),
          const Expanded(child: _Orders()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {},
          child: const Text('Finish Order'),
        ),
      ),
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Orders', style: textTheme.titleLarge),
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Orders extends StatelessWidget {
  const _Orders();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationBloc, ReservationState>(
      builder: (context, state) {
        if (state.status == ReservationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        final orderIds = state.invoice.orderIds;

        return ReservationOrderList(
          orderIds: orderIds,
          packageTrailing: (context, cart) {
            return RefillButton(
              key: ValueKey('refillButton_${cart.id}'),
              startTime: state.reservation.startTime,
              durationMinutes: cart.item.timeLimit,
              onPressed: () {},
              child: const Text('Refill'),
            );
          },
        );
      },
    );
  }
}
