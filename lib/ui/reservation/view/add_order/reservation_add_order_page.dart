import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/event/event_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/list/inventory_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/order/reservation_order_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/ui/reservation/view/add_order/reservation_add_order_screen.dart';

@RoutePage()
class ReservationAddOrderPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationAddOrderPage({
    this.onSuccess,
    this.excludeItemIds = const [],
    super.key,
  });

  final void Function()? onSuccess;
  final List<String> excludeItemIds;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationOrderBloc, ReservationOrderState>(
      listener: (context, state) {
        if (state.status == ReservationOrderStatus.loading) {
          showLoadingDialog(context: context, message: 'Adding Order...');
        }

        if (state.status == ReservationOrderStatus.pure) {
          goToPreviousRoute(context);
        }

        if (state.status == ReservationOrderStatus.success) {
          context.router.pop();
          context.router.pop();

          final router = context.router.parent<StackRouter>();
          router?.pop();

          final reservationId = context
              .read<ReservationBloc>()
              .state
              .reservation
              .id;
          final tableNumber = context
              .read<ReservationBloc>()
              .state
              .table
              .number;
          context.read<EventBloc>().add(
            EventEvent.itemsAdded(
              reservationId: reservationId,
              tableNumber: tableNumber,
              orders: state.orders,
            ),
          );

          onSuccess?.call();
        }

        if (state.status == ReservationOrderStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Failed to add order',
          );
        }
      },
      child: const ReservationAddOrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InventoryListBloc(
            inventoryRepository: context.read(),
            excludeItemIds: excludeItemIds,
            categories: InventoryCategory.values
                .where(
                  (c) =>
                      c != InventoryCategory.unknown ||
                      c != InventoryCategory.storage,
                )
                .toList(),
          )..add(const InventoryListEvent.started()),
        ),
      ],
      child: this,
    );
  }
}
