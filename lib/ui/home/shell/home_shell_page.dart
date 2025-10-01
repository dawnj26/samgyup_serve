import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:event_repository/event_repository.dart' hide EventStatus;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';

@RoutePage()
class HomeShellPage extends StatelessWidget implements AutoRouteWrapper {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final session = state.session;
        final status = state.status;

        return AutoRouter.declarative(
          routes: (handler) {
            if (status == HomeStatus.loading || status == HomeStatus.initial) {
              return [
                LoadingRoute(message: 'Preparing ingredients...'),
              ];
            }

            if (session == SessionStatus.order) {
              return [const OrderShellRoute()];
            }

            if (session == SessionStatus.reservation) {
              return [
                const ReservationOrderRoute(),
              ];
            }

            if (session == SessionStatus.payment) {
              return [
                PaymentOrderRoute(
                  invoiceId: state.invoiceId,
                ),
              ];
            }

            return [
              const HomeRoute(),
              if (session == SessionStatus.login) const LoginRoute(),
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
        RepositoryProvider(
          create: (context) => EventRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ActivityBloc(),
          ),
          BlocProvider(
            create: (context) => EventBloc(
              eventRepository: context.read<EventRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) {
              final table = context.read<AppBloc>().state.deviceData?.table;

              return HomeBloc(
                eventRepo: context.read<EventRepository>(),
                reservationRepo: context.read<ReservationRepository>(),
              )..add(HomeEvent.started(table: table));
            },
          ),
        ],
        child: BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state.status == EventStatus.success) {
              showSnackBar(context, 'Notified the staff');
            }

            if (state.status == EventStatus.failure) {
              showErrorDialog(
                context: context,
                message: state.errorMessage ?? 'Failed to notify staff',
              );
            }
          },
          child: this,
        ),
      ),
    );
  }
}
