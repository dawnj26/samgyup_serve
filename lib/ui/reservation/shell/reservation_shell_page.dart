import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ReservationShellPage extends AutoRouter implements AutoRouteWrapper {
  const ReservationShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
