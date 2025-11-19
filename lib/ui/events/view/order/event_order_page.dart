import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/ui/events/view/order/event_order_screen.dart';

@RoutePage()
class EventOrderPage extends StatelessWidget implements AutoRouteWrapper {
  const EventOrderPage({required this.orders, required this.event, super.key});

  final List<Order> orders;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return EventOrderScreen(
      event: event,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MenuRepository(),
        ),
        RepositoryProvider(
          create: (context) => PackageRepository(),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final orderIds = orders.map((e) => e.id).toList();

              return OrderListBloc(
                orderRepository: context.read<OrderRepository>(),
                inventoryRepository: context.read(),
                packageRepository: context.read(),
              )..add(
                OrderListEvent.started(orderIds: orderIds),
              );
            },
          ),
        ],
        child: this,
      ),
    );
  }
}
