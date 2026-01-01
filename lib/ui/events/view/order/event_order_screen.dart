import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/event/order/event_order_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/order/status/order_status_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/order/components/order_status_dropdown.dart';
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
        Expanded(
          child: ReservationOrderList(
            packageTrailing: (context, item) {
              return BlocProvider(
                key: ValueKey('order_status_bloc_${item.id}'),
                create: (context) =>
                    OrderStatusBloc(
                      orderRepository: context.read<OrderRepository>(),
                      initialStatus: item.status,
                      orderId: item.id,
                    )..add(
                      const OrderStatusEvent.started(),
                    ),
                child: _StatusDropdown(
                  item: item,
                ),
              );
            },
            menuTrailing: (context, item) {
              return BlocProvider(
                key: ValueKey('order_status_bloc_${item.id}'),
                create: (context) =>
                    OrderStatusBloc(
                      orderRepository: context.read<OrderRepository>(),
                      initialStatus: item.status,
                      orderId: item.id,
                    )..add(
                      const OrderStatusEvent.started(),
                    ),
                child: _StatusDropdown(
                  item: item,
                ),
              );
            },
          ),
        ),
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
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: _CompleteButton(),
      ),
    );
  }
}

class _CompleteButton extends StatelessWidget {
  const _CompleteButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (OrderListBloc bloc) => bloc.state.status,
    );

    final enabled = status == OrderListStatus.success;

    return FilledButton(
      onPressed: enabled
          ? () {
              final mItems = context.read<OrderListBloc>().state.menuItems;
              final pItems = context.read<OrderListBloc>().state.packages;

              final ids = [
                ...mItems.map((e) => e.id),
                ...pItems.map((e) => e.id),
              ].toList();

              context.read<EventOrderBloc>().add(
                EventOrderEvent.completedAll(orderIds: ids),
              );
            }
          : null,
      child: const Text('Mark as done'),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.item,
  });

  //
  // ignore: strict_raw_type
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (OrderStatusBloc bloc) => bloc.state.status,
    );

    return OrderStatusDropdown(
      currentStatus: status,
      onChanged: (status) {
        context.read<EventOrderBloc>().add(
          EventOrderEvent.started(
            orderId: item.id,
            newStatus: status,
          ),
        );
      },
    );
  }
}
