import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/menu/list/menu_list_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/ui/reservation/view/refill/reservation_refill_screen.dart';

@RoutePage()
class ReservationRefillPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationRefillPage({
    required this.menuIds,
    required this.quantity,
    super.key,
    this.onSave,
  });

  final List<String> menuIds;
  final int quantity;
  final void Function(List<CartItem<MenuItem>> items)? onSave;

  @override
  Widget build(BuildContext context) {
    return ReservationRefillScreen(
      quantity: quantity,
      onSave: onSave,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuListBloc(
            menuIds: menuIds,
            menuRepository: context.read(),
          )..add(const MenuListEvent.started()),
        ),
        BlocProvider(
          create: (context) => OrderCartBloc(),
        ),
      ],
      child: this,
    );
  }
}
