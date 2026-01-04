import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/reservation/view/billing/reservation_billing_screen.dart';

@RoutePage()
class ReservationBillingPage extends StatelessWidget {
  const ReservationBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReservationBillingScreen();
  }
}
