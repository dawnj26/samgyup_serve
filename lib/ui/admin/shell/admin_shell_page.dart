import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AdminShellPage extends AutoRouter implements AutoRouteWrapper {
  const AdminShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => EventRepository(),
      child: this,
    );
  }
}
