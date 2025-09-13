import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';

@RoutePage()
class HomeShellPage extends AutoRouter implements AutoRouteWrapper {
  const HomeShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityBloc(),
      child: this,
    );
  }
}
