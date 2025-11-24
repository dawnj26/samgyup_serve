import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/reports/hours/peak_hours_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/total/reservation_total_bloc.dart';
import 'package:samgyup_serve/bloc/revenue/revenue_bloc.dart';
import 'package:samgyup_serve/bloc/table/availability/table_availability_bloc.dart';
import 'package:samgyup_serve/ui/dashboard/view/dashboard_screen.dart';

@RoutePage()
class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RevenueBloc(
            billingRepository: context.read<BillingRepository>(),
          )..add(const RevenueEvent.started()),
        ),
        BlocProvider(
          create: (context) => TableAvailabilityBloc(
            tableRepository: context.read(),
          )..add(const TableAvailabilityEvent.started()),
        ),
        BlocProvider(
          create: (context) => ReservationTotalBloc(
            reservationRepository: context.read(),
          )..add(const ReservationTotalEvent.started()),
        ),
        BlocProvider(
          create: (context) => PeakHoursBloc(
            reservationRepository: context.read(),
          )..add(const PeakHoursEvent.started()),
        ),
      ],
      child: this,
    );
  }
}
