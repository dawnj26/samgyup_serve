import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/order/reservation_order_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/inventory_list_item.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class ReservationAddOrderScreen extends StatelessWidget {
  const ReservationAddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Add Order'),
      ),
      body: InfiniteScrollLayout(
        onLoadMore: () => context.read<MenuBloc>().add(
          const MenuEvent.loadMore(),
        ),
        slivers: [
          MenuItemList(
            itemBuilder: (context, menu) {
              final cartItems = context.select(
                (OrderCartBloc bloc) => bloc.state.menuItems,
              );
              final cartIndex = cartItems.indexWhere(
                (e) => e.item.id == menu.id,
              );

              if (cartIndex == -1) {
                return InventoryListItem(
                  item: menu,
                  onTap: menu.isAvailable
                      ? () => _handleItemTap(context, menu)
                      : null,
                );
              }

              final cart = cartItems[cartIndex];
              return Badge.count(
                alignment: Alignment.bottomRight,

                offset: const Offset(-12, -26),
                count: cart.quantity,
                child: InventoryListItem(
                  item: menu,
                  onTap: menu.isAvailable
                      ? () => _handleItemTap(context, menu)
                      : null,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: _CartButton(),
      ),
    );
  }

  Future<void> _handleItemTap(
    BuildContext context,
    InventoryItem item, [
    int? initialValue,
  ]) async {
    final quantity = await showAddCartItemDialog(
      context: context,
      name: item.name,
      description: item.description ?? 'No description available.',
      price: item.price,
      maxQuantity: item.getAvailableStock().toInt(),
      imageId: item.imageId,
      initialValue: initialValue,
    );

    if (!context.mounted || quantity == null) return;

    context.read<OrderCartBloc>().add(
      OrderCartEvent.addMenuItem(
        CartItem(
          item: item,
          quantity: quantity,
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    final cartCount = context.select(
      (OrderCartBloc bloc) =>
          bloc.state.menuItems.length + bloc.state.packages.length,
    );

    return FilledButton(
      onPressed: () => _handlePressed(context),
      child: Text('View Cart ($cartCount)'),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(
      context.router.push(
        OrderCartRoute(
          onOrderStarted: () => _handleOrderStarted(context),
        ),
      ),
    );
  }

  void _handleOrderStarted(BuildContext context) {
    final cart = context.read<OrderCartBloc>().state.menuItems;
    final invoice = context.read<ReservationBloc>().state.invoice;

    context.read<ReservationOrderBloc>().add(
      ReservationOrderEvent.started(
        items: cart,
        invoice: invoice,
      ),
    );
  }
}
