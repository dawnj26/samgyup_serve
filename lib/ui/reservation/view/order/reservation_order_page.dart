import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reservation_repository/reservation_repository.dart' as r;
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/reservation/view/order/reservation_order_screen.dart';

@RoutePage()
class ReservationOrderPage extends StatelessWidget {
  const ReservationOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state.status != ReservationStatus.success) return;

        context.read<OrderListBloc>().add(
          OrderListEvent.started(orderIds: state.invoice.orderIds),
        );

        if (state.reservation.status == r.ReservationStatus.cancelling) {
          unawaited(
            context.router.push(
              ReservationCancelRoute(
                reservationId: state.reservation.id,
                tableNumber: state.table.number,
              ),
            ),
          );
        }
      },
      child: const ReservationOrderScreen(),
    );
  }
}
