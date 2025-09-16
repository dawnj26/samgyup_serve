import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/router/router.dart';

@RoutePage()
class HomeShellPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final status = state.status;
        return AutoRouter.declarative(
          routes: (handler) {
            if (status == HomeStatus.order) {
              return [const OrderShellRoute()];
            }

            return [
              const HomeRoute(),
              if (status == HomeStatus.login) const LoginRoute(),
            ];
          },
        );
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ActivityBloc(),
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
      ],
      child: this,
    );
  }
}
