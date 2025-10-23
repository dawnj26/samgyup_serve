import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/cancel/reservation_cancel_bloc.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/ui/reservation/view/cancel/reservation_cancel_screen.dart';

@RoutePage()
class ReservationCancelPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationCancelPage({
    required this.reservationId,
    required this.tableNumber,
    super.key,
  });

  final String reservationId;
  final int tableNumber;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationCancelBloc, ReservationCancelState>(
      listener: (context, state) {
        final homeBloc = context.read<HomeBloc>();

        if (state.status == ReservationCancelStatus.success) {
          homeBloc.add(const HomeEvent.statusChanged(SessionStatus.initial));
        }

        if (state.status == ReservationCancelStatus.cancelled) {
          goToPreviousRoute(context);
        }

        if (state.status == ReservationCancelStatus.inProgress) {
          context.read<EventBloc>().add(
            EventEvent.orderCancelled(
              reservationId: reservationId,
              tableNumber: tableNumber,
            ),
          );
        }
      },
      child: const ReservationCancelScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReservationCancelBloc(
            reservationRepository: context.read(),
          )..add(
            ReservationCancelEvent.started(reservationId: reservationId),
          ),
      child: this,
    );
  }
}
