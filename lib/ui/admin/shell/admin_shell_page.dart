import 'dart:async';
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/bloc/event/list/event_list_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:table_repository/table_repository.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class AdminShellPage extends StatelessWidget implements AutoRouteWrapper {
  const AdminShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => EventRepository(),
        ),
        RepositoryProvider(
          create: (context) => BillingRepository(),
        ),
        RepositoryProvider(
          create: (context) => TableRepository(),
        ),
        RepositoryProvider(
          create: (context) => ReservationRepository(),
        ),
        RepositoryProvider(
          create: (context) => SettingsRepository(),
        ),
        RepositoryProvider(
          create: (context) => InventoryRepository(),
        ),
      ],
      child: BlocProvider(
        create: (context) => EventListBloc(
          eventRepository: context.read(),
        )..add(const EventListEvent.started()),
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AutoRouter(
      builder: (context, content) {
        return BlocListener<EventListBloc, EventListState>(
          listenWhen: (p, c) => p.latestEvent != c.latestEvent,
          listener: (context, state) {
            final event = state.latestEvent;

            if (event == null) return;

            toastification.show(
              title: Text('Table ${event.tableNumber} ${event.type.message}'),
              type: ToastificationType.info,
              style: ToastificationStyle.minimal,
              autoCloseDuration: const Duration(seconds: 5),
              callbacks: ToastificationCallbacks(
                onTap: (item) {
                  toastification.dismissById(item.id);

                  final json =
                      jsonDecode(event.payload) as Map<String, dynamic>? ?? {};
                  final data = json['data'] as Map<String, dynamic>? ?? {};

                  if (event.type == EventType.orderCreated ||
                      event.type == EventType.itemsAdded) {
                    final orders = data['orders'] as List<dynamic>? ?? [];
                    final eventOrders = orders
                        .map((e) => Order.fromJson(e as Map<String, dynamic>))
                        .toList();

                    unawaited(
                      context.router.push(
                        EventOrderRoute(orders: eventOrders, event: event),
                      ),
                    );
                  }

                  if (event.type == EventType.refillRequested) {
                    unawaited(
                      context.router.push(
                        EventRefillRoute(event: event),
                      ),
                    );
                  }

                  if (event.type == EventType.paymentRequested) {
                    final invoiceId = data['invoiceId'] as String? ?? '';

                    unawaited(
                      context.router.push(
                        EventPaymentRoute(
                          invoiceId: invoiceId,
                          event: event,
                        ),
                      ),
                    );
                  }

                  if (event.type == EventType.orderCancelled) {
                    unawaited(
                      context.router.push(
                        EventCancelRoute(event: event),
                      ),
                    );
                  }
                },
              ),
            );
          },
          child: content,
        );
      },
    );
  }
}
