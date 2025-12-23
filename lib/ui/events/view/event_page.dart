import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/events/view/event_screen.dart';

@RoutePage()
class EventPage extends StatelessWidget implements AutoRouteWrapper {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventActionsBloc, EventActionsState>(
      listener: (context, state) {
        if (state.status == EventActionsStatus.loading) {
          showLoadingDialog(context: context, message: 'Processing...');
        }

        if (state.status == EventActionsStatus.success) {
          context.router.pop();
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
      child: const EventScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EventActionsBloc(
            eventRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
