import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
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

            if (status == HomeStatus.reservation) {
              return [
                ReservationOrderRoute(reservationId: state.reservationId),
              ];
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MenuRepository(),
        ),
        RepositoryProvider(
          create: (context) => PackageRepository(),
        ),
        RepositoryProvider(
          create: (context) => OrderRepository(),
        ),
        RepositoryProvider(
          create: (context) => BillingRepository(),
        ),
        RepositoryProvider(
          create: (context) => ReservationRepository(),
        ),
      ],
      child: this,
    );
  }
}
