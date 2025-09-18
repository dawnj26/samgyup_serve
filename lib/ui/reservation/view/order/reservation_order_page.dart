import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/ui/reservation/view/order/reservation_order_screen.dart';

@RoutePage()
class ReservationOrderPage extends StatelessWidget implements AutoRouteWrapper {
  const ReservationOrderPage({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state.status == ReservationStatus.success) {
          context.read<OrderListBloc>().add(
            OrderListEvent.started(orderIds: state.invoice.orderIds),
          );
        }
      },
      child: const ReservationOrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ReservationBloc(
                tableRepository: context.read(),
                reservationRepository: context.read(),
                billingRepository: context.read(),
              )..add(
                ReservationEvent.started(reservationId: reservationId),
              ),
        ),
        BlocProvider(
          create: (context) => OrderListBloc(
            orderRepository: context.read(),
            menuRepository: context.read(),
            packageRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
