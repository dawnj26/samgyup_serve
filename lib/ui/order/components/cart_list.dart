import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

class CartList extends StatelessWidget {
  const CartList({
    required this.menus,
    required this.packages,
    super.key,
    this.packageTrailing,
    this.menuTrailing,
  });

  final List<CartItem<MenuItem>> menus;
  final List<CartItem<FoodPackage>> packages;

  final Widget Function(BuildContext context, CartItem<FoodPackage> cart)?
  packageTrailing;
  final Widget Function(BuildContext context, CartItem<MenuItem> cart)?
  menuTrailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text('Packages', style: textTheme.labelLarge),
          ),
        ),
        if (packages.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('No packages added.', style: textTheme.bodyMedium),
            ),
          )
        else
          SliverList.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final cartItem = packages[index];
              final package = cartItem.item;

              return OrderTile(
                name: package.name,
                price: package.price,
                quantity: cartItem.quantity,
                imageId: package.imageFilename,
                trailing: packageTrailing?.call(context, cartItem),
              );
            },
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text('Menu Items', style: textTheme.labelLarge),
          ),
        ),
        if (menus.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('No menu items added.', style: textTheme.bodyMedium),
            ),
          )
        else
          SliverList.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final cartItem = menus[index];
              final menu = cartItem.item;

              return OrderTile(
                name: menu.name,
                price: menu.price,
                quantity: cartItem.quantity,
                imageId: menu.imageFileName,
                trailing: menuTrailing?.call(context, cartItem),
              );
            },
          ),
      ],
    );
  }
}
