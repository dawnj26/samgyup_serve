import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/bloc/refill/refill_bloc.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

class EventRefillScreen extends StatelessWidget {
  const EventRefillScreen({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(event.type.label),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Table #${event.tableNumber}',
                style: textTheme.headlineLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                'Items',
                style: textTheme.labelLarge,
              ),
            ),
          ),
          const _List(),
        ],
      ),
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

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RefillBloc, RefillState>(
      builder: (context, state) {
        if (state.status == RefillStatus.loading ||
            state.status == RefillStatus.initial) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == RefillStatus.failure) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('Failed to load refill data: ${state.errorMessage}'),
            ),
          );
        }

        final cart = state.orders;

        if (cart.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No items')),
          );
        }

        return SliverList.builder(
          itemCount: cart.length,
          itemBuilder: (context, index) {
            final cartItem = cart[index];
            return OrderTile(
              name: cartItem.item.name,
              price: cartItem.item.price,
              quantity: cartItem.quantity,
              imageId: cartItem.item.imageFileName,
            );
          },
        );
      },
    );
  }
}
