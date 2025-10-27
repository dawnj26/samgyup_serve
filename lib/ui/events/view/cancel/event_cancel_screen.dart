import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/cancel/cancel_bloc.dart';
import 'package:samgyup_serve/bloc/event/reservation/reservation_events_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/events/components/components.dart';

class EventCancelScreen extends StatelessWidget {
  const EventCancelScreen({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            leading: const AutoLeadingButton(),
            title: Text(event.type.label),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Table #${event.tableNumber}',
                        style: textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created at: ${formatTime(event.createdAt!.toLocal())}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Text(
                'Event history',
                style: textTheme.labelLarge,
              ),
            ),
          ),
          const _Events(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () async {
                final confirm = await showConfirmationDialog(
                  context: context,
                  title: 'Accept Cancellation',
                  message: 'Are you sure you want to accept this cancellation?',
                );

                if (!context.mounted || !confirm) return;

                context.read<CancelBloc>().add(
                  CancelEvent.started(
                    reservationId: event.reservationId,
                  ),
                );
              },
              child: const Text('Accept'),
            ),
            TextButton(
              onPressed: () async {
                final confirm = await showConfirmationDialog(
                  context: context,
                  title: 'Decline Cancellation',
                  message:
                      'Are you sure you want to decline this cancellation?',
                );

                if (!context.mounted || !confirm) return;

                context.read<CancelBloc>().add(
                  CancelEvent.cancelled(
                    reservationId: event.reservationId,
                  ),
                );
              },
              child: const Text('Decline'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Events extends StatelessWidget {
  const _Events();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationEventsBloc, ReservationEventsState>(
      builder: (context, state) {
        if (state.status == LoadingStatus.loading ||
            state.status == LoadingStatus.initial) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == LoadingStatus.failure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        }

        final events = state.events;

        if (events.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('No events found.'),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverList.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final gap = index != events.length - 1 ? 8.0 : 0.0;

              return Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, gap),
                child: EventCard(event: event),
              );
            },
          ),
        );
      },
    );
  }
}
