import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/order/view/cart/order_cart_screen.dart';

@RoutePage()
class OrderCartPage extends StatelessWidget {
  const OrderCartPage({super.key, this.onOrderStarted, this.onPointerDown});

  final void Function()? onOrderStarted;
  final void Function()? onPointerDown;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => onPointerDown?.call(),
      child: OrderCartScreen(
        onOrderStarted: onOrderStarted,
      ),
    );
  }
}
