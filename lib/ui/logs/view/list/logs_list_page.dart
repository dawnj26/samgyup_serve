import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/log/log_list_bloc.dart';
import 'package:samgyup_serve/ui/logs/view/list/logs_list_screen.dart';

@RoutePage()
class LogsListPage extends StatelessWidget implements AutoRouteWrapper {
  const LogsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LogsListScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LogListBloc()
        ..add(
          const LogListEvent.started(),
        ),
      child: this,
    );
  }
}
