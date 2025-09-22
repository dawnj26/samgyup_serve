import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
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
              onTap: () => _handleTap(context),
            ),
          ),
          const Expanded(child: _Orders()),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () => _handlePressed(context),
          child: const Text('Proceed to billing'),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    unawaited(
      context.router.push(
        ReservationAddOrderRoute(
          onSuccess: () {
            context.read<ReservationBloc>().add(
              const ReservationEvent.refreshed(),
            );
          },
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(context.router.push(const ReservationBillingRoute()));
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

        return ReservationOrderList(
          packageTrailing: (context, cart) {
            return RefillButton(
              key: ValueKey('refillButton_${cart.id}'),
              startTime: state.reservation.startTime,
              durationMinutes: cart.item.timeLimit,
              onPressed: () {
                final endTime = state.reservation.startTime.add(
                  Duration(
                    minutes: cart.item.timeLimit,
                  ),
                );
                final diff = endTime.difference(DateTime.now());

                if (diff.isNegative) return;

                _handlePressed(
                  context,
                  cart,
                  state.reservation.id,
                  state.table.number,
                );
              },
              child: const Text('Request'),
            );
          },
        );
      },
    );
  }

  void _handlePressed(
    BuildContext context,
    CartItem<FoodPackage> cart,
    String reservationId,
    int tableNumber,
  ) {
    unawaited(
      context.router.push(
        ReservationRefillRoute(
          menuIds: cart.item.menuIds,
          quantity: cart.quantity,
          onSave: (items) {
            if (items.isEmpty) return;

            context.read<EventBloc>().add(
              EventEvent.refillRequested(
                reservationId: reservationId,
                tableNumber: tableNumber,
                items: items,
              ),
            );
          },
        ),
      ),
    );
  }
}
