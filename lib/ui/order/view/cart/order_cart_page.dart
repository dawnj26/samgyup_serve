import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/ui/order/view/cart/order_cart_screen.dart';

@RoutePage()
class OrderCartPage extends StatelessWidget {
  const OrderCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => context.read<ActivityBloc>().add(
        const ActivityEvent.started(),
      ),
      child: const OrderCartScreen(),
    );
  }
}
