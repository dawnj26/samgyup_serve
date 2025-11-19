import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
import 'package:table_repository/table_repository.dart';

@RoutePage()
class OrderShellPage extends AutoRouter implements AutoRouteWrapper {
  const OrderShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderCartBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(
            inventoryRepository: context.read<InventoryRepository>(),
            orderRepository: context.read<OrderRepository>(),
            billingRepository: context.read<BillingRepository>(),
            reservationRepository: context.read<ReservationRepository>(),
            tableRepository: context.read<TableRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
