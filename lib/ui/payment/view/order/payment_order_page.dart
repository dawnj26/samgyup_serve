import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/payment/order/payment_order_bloc.dart';
import 'package:samgyup_serve/ui/payment/view/order/payment_order_screen.dart';

@RoutePage()
class PaymentOrderPage extends StatelessWidget implements AutoRouteWrapper {
  const PaymentOrderPage({required this.invoiceId, super.key});

  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentOrderBloc, PaymentOrderState>(
      listener: (context, state) {
        if (state.status == PaymentOrderStatus.success) {
          context.read<HomeBloc>().add(
            const HomeEvent.statusChanged(SessionStatus.initial),
          );
        }
      },
      child: const PaymentOrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentOrderBloc(
        billingRepository: context.read(),
      )..add(PaymentOrderEvent.started(invoiceId: invoiceId)),
      child: this,
    );
  }
}
