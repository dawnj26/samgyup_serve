import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/menu/list/menu_list_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/ui/menu/components/menu_list_item.dart';

class ReservationRefillScreen extends StatelessWidget {
  const ReservationRefillScreen({
    required this.quantity,
    super.key,
    this.onSave,
  });

  final void Function(List<CartItem<MenuItem>> items)? onSave;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refill'),
      ),
      body: BlocBuilder<MenuListBloc, MenuListState>(
        builder: (context, state) {
          if (state.status == MenuListStatus.loading ||
              state.status == MenuListStatus.initial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.status == MenuListStatus.failure) {
            return const Center(
              child: Text('Failed to load menu items.'),
            );
          }

          final items = state.items;

          if (items.isEmpty) {
            return const Center(
              child: Text('No menu items available for refill.'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _Item(
                item: item,
                quantity: quantity,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final cartItems = context.read<OrderCartBloc>().state.menuItems;
          onSave?.call(cartItems);

          goToPreviousRoute(context);
        },
        label: const Text('Request'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    required this.quantity,
  });

  final MenuItem item;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select(
      (OrderCartBloc bloc) => bloc.state.menuItems,
    );
    final cartIndex = cartItems.indexWhere(
      (e) => e.item.id == item.id,
    );

    if (cartIndex != -1) {
      final cart = cartItems[cartIndex];
      return Badge.count(
        alignment: Alignment.bottomRight,
        offset: const Offset(-12, -26),
        count: cart.quantity,
        child: MenuListItem(
          item: item,
          onTap: () => _handleItemTap(context, item),
        ),
      );
    }

    return MenuListItem(
      item: item,
      onTap: () => _handleItemTap(context, item),
    );
  }

  Future<void> _handleItemTap(
    BuildContext context,
    MenuItem item, [
    int? initialValue,
  ]) async {
    if (!item.isAvailable) return;

    final quantity = await showAddCartItemDialog(
      context: context,
      name: item.name,
      description: item.description,
      price: item.price,
      maxQuantity: this.quantity,
      imageId: item.imageFileName,
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
