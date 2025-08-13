import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/dashboard/view/dashboard_screen.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardScreen();
  }
}
