import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart' hide OrderType;
import 'package:package_repository/package_repository.dart';
import 'package:reservation_repository/reservation_repository.dart'
    show Reservation;
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/order/status/order_status_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';
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
        actions: [
          ReservationMoreOptionsButton(
            onSelected: (value) => _handleMoreOptions(context, value),
          ),
        ],
      ),
      body: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state.status == ReservationStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
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
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ReservationBloc, ReservationState>(
        builder: (context, state) {
          if (state.status == ReservationStatus.loading) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: () => _handlePressed(context),
              child: const Text('Proceed to billing'),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    final type = await SelectOrderSheet.show(context);
    log('Selected order type: $type', name: '_handleTap');

    if (!context.mounted || type == null) return;

    switch (type) {
      case OrderType.item:
        final packages = context.read<OrderListBloc>().state.packages;
        final uniqueMenuIds = packages
            .expand((e) => e.item.menuIds)
            .toSet()
            .toList();

        unawaited(
          context.router.push(
            ReservationAddOrderRoute(
              excludeItemIds: uniqueMenuIds,
              onSuccess: () {
                context.read<ReservationBloc>().add(
                  const ReservationEvent.refreshed(),
                );
              },
            ),
          ),
        );
      case OrderType.package:
        unawaited(
          context.router.push(
            ReservationAddPackageRoute(
              onSuccess: () {
                context.read<ReservationBloc>().add(
                  const ReservationEvent.refreshed(),
                );
              },
            ),
          ),
        );
    }
  }

  Future<void> _handleMoreOptions(
    BuildContext context,
    ReservationMoreOptionsButtonType option,
  ) async {
    switch (option) {
      case ReservationMoreOptionsButtonType.cancel:
        final confirm = await showConfirmationDialog(
          context: context,
          title: 'Cancel Order',
          message: 'Your order will be reviewed by the staff. Are you sure?',
        );

        if (!context.mounted || !confirm) return;

        final rState = context.read<ReservationBloc>().state;

        await context.router.push(
          ReservationCancelRoute(
            reservationId: rState.reservation.id,
            tableNumber: rState.table.number,
          ),
        );
    }
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
            return BlocProvider(
              create: (context) => OrderStatusBloc(
                orderRepository: context.read<OrderRepository>(),
                initialStatus: cart.status,
                orderId: cart.id,
              )..add(const OrderStatusEvent.started()),
              child:
                  BlocSelector<OrderStatusBloc, OrderStatusState, OrderStatus>(
                    selector: (state) {
                      return state.status;
                    },
                    builder: (context, status) {
                      final enabled = status == OrderStatus.completed;
                      final label = enabled ? 'Refill' : status.label;

                      return RefillButton(
                        key: ValueKey('refillButton_${cart.id}'),
                        startTime: state.reservation.startTime,
                        durationMinutes: cart.item.timeLimit,
                        enabled: enabled,
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
                            state.reservation,
                            state.table.number,
                          );
                        },
                        child: Text(label),
                      );
                    },
                  ),
            );
          },
          menuTrailing: (ctx, cart) {
            return _Status(
              cart: cart,
            );
          },
        );
      },
    );
  }

  void _handlePressed(
    BuildContext context,
    CartItem<FoodPackage> cart,
    Reservation reservation,
    int tableNumber,
  ) {
    unawaited(
      context.router.push(
        ReservationRefillRoute(
          package: cart.item,
          startTime: reservation.startTime,
          quantity: cart.quantity,
          onSave: (items) {
            if (items.isEmpty) return;

            context.read<EventBloc>().add(
              EventEvent.refillRequested(
                reservationId: reservation.id,
                tableNumber: tableNumber,
                items: items,
                orderPackageId: cart.id,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({
    required this.cart,
  });

  final CartItem<InventoryItem> cart;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderStatusBloc(
        orderRepository: context.read<OrderRepository>(),
        initialStatus: cart.status,
        orderId: cart.id,
      )..add(const OrderStatusEvent.started()),
      child: Builder(
        builder: (context) {
          final status = context.select(
            (OrderStatusBloc bloc) => bloc.state.status,
          );

          return OrderStatusBadge(
            status: status,
          );
        },
      ),
    );
  }
}
