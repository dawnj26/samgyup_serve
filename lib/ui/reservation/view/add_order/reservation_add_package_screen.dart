import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/tab/food_package_tab_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/order/reservation_order_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';
import 'package:samgyup_serve/ui/order/components/components.dart';

class ReservationAddPackageScreen extends StatelessWidget {
  const ReservationAddPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Add Package'),
      ),
      body: const _Tab(),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: _CartButton(),
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
    final cart = context.read<OrderCartBloc>().state.packages;
    final invoice = context.read<ReservationBloc>().state.invoice;

    context.read<ReservationOrderBloc>().add(
      ReservationOrderEvent.started(
        items: [],
        packages: cart,
        invoice: invoice,
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab();

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<FoodPackageTabBloc>()
          ..add(const FoodPackageTabEvent.refresh());

        await bloc.stream.firstWhere(
          (state) => state.status != FoodPackageTabStatus.refreshing,
        );
      },
      child: InfiniteScrollLayout(
        onLoadMore: () {
          context.read<FoodPackageTabBloc>().add(
            const FoodPackageTabEvent.fetchMore(),
          );
        },
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: const [
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: _PackageList(),
          ),
          SliverToBoxAdapter(
            child: _BottomLoader(),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PackageList extends StatelessWidget {
  const _PackageList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageTabBloc, FoodPackageTabState>(
      builder: (context, state) {
        switch (state.status) {
          case FoodPackageTabStatus.initial || FoodPackageTabStatus.loading:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case FoodPackageTabStatus.success || FoodPackageTabStatus.refreshing:
            final packages = state.items;

            if (packages.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text('No packages available.'),
                ),
              );
            }

            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 1,
              ),
              itemCount: packages.length,
              itemBuilder: (ctx, i) {
                final package = packages[i];

                return _Item(package: package);
              },
            );
          case FoodPackageTabStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Error: ${state.errorMessage}'),
              ),
            );
        }
      },
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    final hasReachedMax = context.select(
      (FoodPackageTabBloc bloc) => bloc.state.hasReachedMax,
    );

    if (hasReachedMax) {
      return const SizedBox.shrink();
    }
    return const BottomLoader();
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.package});

  final FoodPackageFull package;

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select(
      (OrderCartBloc bloc) => bloc.state.packages,
    );
    final cartIndex = cartItems.indexWhere((e) => e.item.id == package.id);
    final unavailableItems = package.items
        .where((item) => !item.isAvailable)
        .toList();

    final isAvailable = unavailableItems.length != package.items.length;

    if (cartIndex == -1) {
      return PackageTile(
        onTap: () =>
            _handlePackageTap(context, package, unavailableItems, isAvailable),
        package: package,
        isAvailable: isAvailable,
      );
    }

    final cart = cartItems[cartIndex];

    return Badge.count(
      count: cart.quantity,
      alignment: Alignment.bottomRight,
      offset: const Offset(-16, -12),
      child: PackageTile(
        isAvailable: isAvailable,
        onTap: () => _handlePackageTap(
          context,
          package,
          unavailableItems,
          isAvailable,
          cart.quantity,
        ),
        package: package,
      ),
    );
  }

  Future<void> _handlePackageTap(
    BuildContext context,
    FoodPackageFull package,
    List<InventoryItem> unavailableItems,
    bool isAvailable, [
    int? initialValue,
  ]) async {
    if (!isAvailable) return;

    final tableSize = context
        .read<ReservationBloc>()
        .state
        .reservation
        .customerCount;
    final timeLimit = package.timeLimit / 60;

    final quantity = await showAddCartItemDialog(
      initialValue: initialValue,
      context: context,
      name: '${package.name} (${timeLimit.toStringAsFixed(1)} hr)',
      description: package.description,
      price: package.price,
      maxQuantity: tableSize,
      imageId: package.imageFilename,
      content: PackageMenuList(
        menus: package.items,
      ),
    );

    if (!context.mounted || quantity == null) return;

    var confirm = true;

    if (unavailableItems.isNotEmpty) {
      final itemNames = unavailableItems.map((e) => e.name).join(', ');
      confirm = await showConfirmationDialog(
        context: context,
        title: 'Unavailable Items',
        message:
            'The following items are unavailable: $itemNames. '
            'Do you want to proceed adding the package to the cart?',
      );
    }

    if (!context.mounted || !confirm) return;

    final p = FoodPackageItem(
      id: package.id,
      name: package.name,
      description: package.description,
      price: package.price,
      timeLimit: package.timeLimit,
      imageFilename: package.imageFilename,
      menuIds: package.menuIds,
      createdAt: package.createdAt,
    );

    context.read<OrderCartBloc>().add(
      OrderCartEvent.addPackage(
        CartItem(
          item: p,
          quantity: quantity,
        ),
      ),
    );
  }
}
