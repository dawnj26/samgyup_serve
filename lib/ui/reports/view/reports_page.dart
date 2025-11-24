import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/reports/view/reports_screen.dart';

@RoutePage()
class ReportsPage extends StatelessWidget implements AutoRouteWrapper {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReportsScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
