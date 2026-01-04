import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/order/reservation_order_bloc.dart';

@RoutePage()
class ReservationAddOrderWrapperPage extends AutoRouter
    implements AutoRouteWrapper {
  const ReservationAddOrderWrapperPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OrderCartBloc(),
        ),
        BlocProvider(
          create: (context) => ReservationOrderBloc(
            billingRepository: context.read(),
            inventoryRepository: context.read(),
            orderRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
