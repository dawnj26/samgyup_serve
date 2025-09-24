import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/shared/snackbar.dart';

@RoutePage()
class EventDetailsShellPage extends AutoRouter implements AutoRouteWrapper {
  const EventDetailsShellPage({super.key});

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
      ],
      child: BlocProvider(
        create: (context) => EventActionsBloc(
          eventRepository: context.read(),
        ),
        child: BlocListener<EventActionsBloc, EventActionsState>(
          listener: (context, state) {
            if (state.status == EventActionsStatus.loading) {
              showLoadingDialog(context: context, message: 'Processing...');
            }

            if (state.status == EventActionsStatus.success) {
              context.router.pop();
              goToPreviousRoute(context);
              showSnackBar(context, state.message);
            }

            if (state.status == EventActionsStatus.failure) {
              context.router.pop();
              showErrorDialog(
                context: context,
                message: state.errorMessage ?? 'An unknown error occurred',
              );
            }
          },
          child: this,
        ),
      ),
    );
  }
}
