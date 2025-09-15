import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

class OrderCartScreen extends StatelessWidget {
  const OrderCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          TextButton(
            onPressed: () => _handleClearCart(context),
            child: const Text('Clear All'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                'Menus',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          const _MenuItems(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(
                'Packages',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          const _PackageItems(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: textTheme.titleMedium,
                ),
                const _TotalPrice(),
              ],
            ),
            const SizedBox(height: 8),
            const _CheckoutButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleClearCart(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context: context,
      message: 'Clear all items in cart?',
      title: 'Clear Cart',
    );

    if (!context.mounted || !confirm) return;

    context.read<OrderCartBloc>().add(
      const OrderCartEvent.clearCart(),
    );
  }
}

class _TotalPrice extends StatelessWidget {
  const _TotalPrice();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = context.select(
      (OrderCartBloc bloc) => bloc.state.totalPrice,
    );

    return Text(
      CurrencyFormatter.formatToPHP(total),
      style: textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton();

  @override
  Widget build(BuildContext context) {
    final menuCart = context.select(
      (OrderCartBloc bloc) => bloc.state.menuItems,
    );
    final packageCart = context.select(
      (OrderCartBloc bloc) => bloc.state.packages,
    );

    final canCheckout = menuCart.isNotEmpty || packageCart.isNotEmpty;

    return FilledButton(
      onPressed: canCheckout ? () {} : null,
      child: const Text('Start Order'),
    );
  }
}

class _PackageItems extends StatelessWidget {
  const _PackageItems();

  @override
  Widget build(BuildContext context) {
    final packageItems = context.select(
      (OrderCartBloc bloc) => bloc.state.packages,
    );
    final capacity = context.select(
      (AppBloc bloc) => bloc.state.deviceData!.table!.capacity,
    );

    if (packageItems.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No packages in cart',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: packageItems.length,
      itemBuilder: (context, index) {
        final cart = packageItems[index];
        final price = cart.item.price * cart.quantity;

        return CartTile(
          name: cart.item.name,
          price: price,
          quantity: cart.quantity,
          imageId: cart.item.imageFilename,
          maxValue: capacity,
          onQuantityChanged: (quantity) {
            context.read<OrderCartBloc>().add(
              OrderCartEvent.updatePackageQuantity(
                index,
                quantity,
              ),
            );
          },
          onDelete: () => _handleDeleteItem(context, cart),
        );
      },
    );
  }

  Future<void> _handleDeleteItem(
    BuildContext context,
    CartItem<FoodPackage> item,
  ) async {
    final confirm = await showConfirmationDialog(
      context: context,
      message: 'Remove package from cart?',
      title: 'Remove Package',
    );

    if (!context.mounted || !confirm) return;

    context.read<OrderCartBloc>().add(
      OrderCartEvent.removePackage(
        item,
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems();

  @override
  Widget build(BuildContext context) {
    final menuItems = context.select(
      (OrderCartBloc bloc) => bloc.state.menuItems,
    );

    if (menuItems.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'No menu items in cart',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final cart = menuItems[index];
        final price = cart.item.price * cart.quantity;

        return CartTile(
          name: cart.item.name,
          price: price,
          quantity: cart.quantity,
          imageId: cart.item.imageFileName,
          maxValue: cart.item.stock,
          onQuantityChanged: (quantity) {
            context.read<OrderCartBloc>().add(
              OrderCartEvent.updateMenuItemQuantity(
                index,
                quantity,
              ),
            );
          },
          onDelete: () => _handleDeleteItem(context, cart),
        );
      },
    );
  }

  Future<void> _handleDeleteItem(
    BuildContext context,
    CartItem<MenuItem> item,
  ) async {
    final confirm = await showConfirmationDialog(
      context: context,
      message: 'Remove item from cart?',
      title: 'Remove Item',
    );

    if (!context.mounted || !confirm) return;

    context.read<OrderCartBloc>().add(
      OrderCartEvent.removeMenuItem(
        item,
      ),
    );
  }
}
