import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';

@RoutePage()
class ReservationAddOrderWrapperPage extends AutoRouter
    implements AutoRouteWrapper {
  const ReservationAddOrderWrapperPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCartBloc(),
      child: this,
    );
  }
}
