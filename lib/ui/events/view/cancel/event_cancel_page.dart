import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/bloc/event/cancel/cancel_bloc.dart';
import 'package:samgyup_serve/bloc/event/reservation/reservation_events_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/events/view/cancel/event_cancel_screen.dart';

@RoutePage()
class EventCancelPage extends StatelessWidget implements AutoRouteWrapper {
  const EventCancelPage({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelBloc, CancelState>(
      listener: (context, state) {
        if (state.status == CancelStatus.accepting ||
            state.status == CancelStatus.declining) {
          final message = state.status == CancelStatus.accepting
              ? 'Accepting cancellation...'
              : 'Declining cancellation...';

          showLoadingDialog(context: context, message: message);
        }

        if (state.status == CancelStatus.success) {
          context.router.pop();
          context.read<EventActionsBloc>().add(
            EventActionsEvent.completed(eventId: event.id),
          );
        }

        if (state.status == CancelStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Something went wrong.',
          );
        }
      },
      child: EventCancelScreen(
        event: event,
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ReservationEventsBloc(
                eventRepository: context.read(),
                reservationId: event.reservationId,
              )..add(
                const ReservationEventsEvent.started(),
              ),
        ),
        BlocProvider(
          create: (context) => CancelBloc(
            reservationRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
