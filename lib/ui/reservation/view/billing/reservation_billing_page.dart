import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/ui/reservation/view/billing/reservation_billing_screen.dart';

@RoutePage()
class ReservationBillingPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReservationBillingScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final invoice = context.read<ReservationBloc>().state.invoice;

        return OrderListBloc(
          orderRepository: context.read(),
          menuRepository: context.read(),
          packageRepository: context.read(),
        )..add(
          OrderListEvent.started(orderIds: invoice.orderIds),
        );
      },
      child: this,
    );
  }
}
