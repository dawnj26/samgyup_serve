import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/bloc/event/list/event_list_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/events/components/components.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final content = InfiniteScrollLayout(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    EventFilterButton(
                      onChanged: (status) {
                        context.read<EventListBloc>().add(
                          EventListEvent.filterChanged(filter: status),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Events',
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    context.read<EventListBloc>().add(
                      const EventListEvent.refreshed(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.all(16), sliver: _List()),
      ],
    );

    if (kIsWeb) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventListBloc, EventListState>(
      builder: (context, state) {
        switch (state.status) {
          case EventListStatus.initial:
          case EventListStatus.loading:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case EventListStatus.success:
            if (state.events.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('No events found'),
                ),
              );
            }
            return SliverList.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                final padding = index != state.events.length - 1
                    ? const EdgeInsets.only(bottom: 8)
                    : null;

                return EventCard(
                  event: event,
                  padding: padding,
                  onTap: (data) {
                    final router = context.router;

                    if (event.type == EventType.orderCreated ||
                        event.type == EventType.itemsAdded) {
                      final orders = data['orders'] as List<dynamic>? ?? [];
                      final eventOrders = orders
                          .map((e) => Order.fromJson(e as Map<String, dynamic>))
                          .toList();

                      unawaited(
                        router.push(
                          EventOrderRoute(orders: eventOrders, event: event),
                        ),
                      );
                    }

                    if (event.type == EventType.refillRequested) {
                      unawaited(
                        router.push(
                          EventRefillRoute(event: event),
                        ),
                      );
                    }

                    if (event.type == EventType.paymentRequested) {
                      final invoiceId = data['invoiceId'] as String? ?? '';

                      unawaited(
                        router.push(
                          EventPaymentRoute(
                            invoiceId: invoiceId,
                            event: event,
                          ),
                        ),
                      );
                    }

                    if (event.type == EventType.orderCancelled) {
                      unawaited(
                        router.push(
                          EventCancelRoute(event: event),
                        ),
                      );
                    }
                  },
                  onMoreTap: (option) => _handleMoreOption(
                    context,
                    option,
                    event,
                  ),
                );
              },
            );
          case EventListStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(state.errorMessage ?? 'Something went wrong!'),
              ),
            );
        }
      },
    );
  }

  Future<void> _handleMoreOption(
    BuildContext context,
    EventMoreOption option,
    Event event,
  ) async {
    switch (option) {
      case EventMoreOption.markAsDone:
        final confirmed = await showConfirmationDialog(
          context: context,
          title: 'Mark as Done',
          message: 'Are you sure you want to mark this event as done?',
        );

        if (!context.mounted || !confirmed) return;

        context.read<EventActionsBloc>().add(
          EventActionsEvent.completed(event: event),
        );
    }
  }
}
