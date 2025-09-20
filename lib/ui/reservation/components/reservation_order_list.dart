import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

class ReservationOrderList extends StatelessWidget {
  const ReservationOrderList({
    super.key,
    this.packageTrailing,
    this.menuTrailing,
  });

  final Widget Function(BuildContext context, CartItem<FoodPackage> cart)?
  packageTrailing;
  final Widget Function(BuildContext context, CartItem<MenuItem> cart)?
  menuTrailing;

  @override
  Widget build(BuildContext context) {
    return _List(
      packageTrailing,
      menuTrailing,
    );
  }
}

class _List extends StatelessWidget {
  const _List(this.packageTrailing, this.menuTrailing);

  final Widget Function(BuildContext context, CartItem<FoodPackage> cart)?
  packageTrailing;
  final Widget Function(BuildContext context, CartItem<MenuItem> cart)?
  menuTrailing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderListBloc, OrderListState>(
      builder: (context, state) {
        switch (state.status) {
          case OrderListStatus.initial || OrderListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case OrderListStatus.failure:
            return Center(
              child: Text('Failed to load orders: ${state.errorMessage}'),
            );
          case OrderListStatus.success:
            return CartList(
              menus: state.menuItems,
              packages: state.packages,
              packageTrailing: packageTrailing,
              menuTrailing: menuTrailing,
            );
        }
      },
    );
  }
}
