import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/table/view/table_screen.dart';

@RoutePage()
class TablePage extends StatelessWidget implements AutoRouteWrapper {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TableScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
