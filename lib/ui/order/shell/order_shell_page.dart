import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderShellPage extends AutoRouter implements AutoRouteWrapper {
  const OrderShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
