import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';

@RoutePage()
class ReservationShellPage extends AutoRouter implements AutoRouteWrapper {
  const ReservationShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final reservationId = context.read<HomeBloc>().state.reservationId;

            return ReservationBloc(
              tableRepository: context.read(),
              reservationRepository: context.read(),
              billingRepository: context.read(),
            )..add(
              ReservationEvent.started(reservationId: reservationId),
            );
          },
        ),
        BlocProvider(
          create: (context) => OrderListBloc(
            orderRepository: context.read(),
            inventoryRepository: context.read(),
            packageRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
