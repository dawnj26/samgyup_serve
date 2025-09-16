import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:samgyup_serve/ui/reservation/view/order/reservation_order_screen.dart';

@RoutePage()
class ReservationOrderPage extends StatelessWidget implements AutoRouteWrapper {
  const ReservationOrderPage({required this.reservationId, super.key});

  final String reservationId;

  @override
  Widget build(BuildContext context) {
    return const ReservationOrderScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
