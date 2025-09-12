import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/order/view/order_screen.dart';

@RoutePage()
class OrderPage extends StatelessWidget implements AutoRouteWrapper {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        // TODO(pointer): implement timer events
        log('Pointer down: ${event.position}', name: 'PointerEvent');
      },
      child: const OrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
