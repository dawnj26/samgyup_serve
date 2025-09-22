import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';

@RoutePage()
class ReservationShellPage extends AutoRouter implements AutoRouteWrapper {
  const ReservationShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
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
      child: this,
    );
  }
}
