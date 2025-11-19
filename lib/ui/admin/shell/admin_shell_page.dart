import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:table_repository/table_repository.dart';

@RoutePage()
class AdminShellPage extends AutoRouter implements AutoRouteWrapper {
  const AdminShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => EventRepository(),
        ),
        RepositoryProvider(
          create: (context) => BillingRepository(),
        ),
        RepositoryProvider(
          create: (context) => TableRepository(),
        ),
        RepositoryProvider(
          create: (context) => ReservationRepository(),
        ),
        RepositoryProvider(
          create: (context) => SettingsRepository(),
        ),
        RepositoryProvider(
          create: (context) => InventoryRepository(),
        ),
      ],
      child: this,
    );
  }
}
