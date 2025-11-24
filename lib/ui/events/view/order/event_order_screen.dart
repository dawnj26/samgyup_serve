import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/reservation/components/components.dart';

class EventOrderScreen extends StatelessWidget {
  const EventOrderScreen({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 15),
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
        const Divider(height: 1),
        const Expanded(child: ReservationOrderList()),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(event.type.label),
      ),
      body: kIsWeb
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: body,
              ),
            )
          : body,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: FilledButton(
          onPressed: () {
            context.read<EventActionsBloc>().add(
              EventActionsEvent.completed(eventId: event.id),
            );
          },
          child: const Text('Mark as done'),
        ),
      ),
    );
  }
}
