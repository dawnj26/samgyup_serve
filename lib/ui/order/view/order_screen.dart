import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/category/category_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';
import 'package:samgyup_serve/ui/order/view/tabs/menu_tab.dart';
import 'package:samgyup_serve/ui/order/view/tabs/package_tab.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryBloc>().state;
    final status = state.status;

    switch (status) {
      case LoadingStatus.initial || LoadingStatus.loading:
        return Scaffold(
          appBar: AppBar(
            leading: const AppLogoIcon(
              size: 40,
              padding: EdgeInsets.all(8),
            ),
            title: const Text('Order'),
          ),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      case LoadingStatus.failure:
        return Scaffold(
          appBar: AppBar(
            leading: const AppLogoIcon(
              size: 40,
              padding: EdgeInsets.all(8),
            ),
            title: const Text('Order'),
          ),
          body: Center(
            child: Text(state.errorMessage ?? 'Something went wrong'),
          ),
        );
      case LoadingStatus.success:
        return _Body(
          categories: state.categories,
        );
    }
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.categories});

  final List<MainCategory> categories;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Widget> _tabs;
  late final List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();

    // Exclude menu categories that are included in unli packages
    final categories = InventoryCategory.values.where(
      (c) => c != InventoryCategory.storage && c != InventoryCategory.unknown,
    );

    _tabs = [
      const Tab(text: 'Unli Packages'),
      ...categories.map((c) => Tab(text: c.label)),
      ...widget.categories.map((c) => Tab(text: c.name)),
    ];
    _tabViews = [
      const PackageTab(),
      ...categories.map((c) => MenuTab(category: c.name)),
      ...widget.categories.map((c) => MenuTab(category: c.name)),
    ];

    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppLogoIcon(
          size: 40,
          padding: EdgeInsets.all(8),
        ),
        title: const Text('Order'),
        bottom: _Bar(controller: _tabController, tabs: _tabs),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabViews,
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(16),
        child: _ViewCartButton(),
      ),
    );
  }
}

class _Bar extends StatelessWidget implements PreferredSizeWidget {
  const _Bar({required this.controller, required this.tabs});

  final TabController controller;
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (CategoryBloc bloc) => bloc.state.status,
    );

    if (status == LoadingStatus.loading || status == LoadingStatus.initial) {
      return const SizedBox.shrink();
    }

    return TabBar(
      controller: controller,
      isScrollable: true,
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(46);
}

class _ViewCartButton extends StatelessWidget {
  const _ViewCartButton();

  @override
  Widget build(BuildContext context) {
    final menuCart = context.select(
      (OrderCartBloc bloc) => bloc.state.menuItems,
    );
    final packageCart = context.select(
      (OrderCartBloc bloc) => bloc.state.packages,
    );

    final cartCount = menuCart.length + packageCart.length;

    return FilledButton(
      onPressed: () => _handlePressed(context),
      child: Text('View Cart ($cartCount)'),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(
      context.router.push(
        OrderCartRoute(
          onOrderStarted: () => _handleCheckout(context),
          onPointerDown: () => context.read<ActivityBloc>().add(
            const ActivityEvent.started(),
          ),
        ),
      ),
    );
  }

  Future<void> _handleCheckout(BuildContext context) async {
    final menuCart = context.read<OrderCartBloc>().state.menuItems;
    final packageCart = context.read<OrderCartBloc>().state.packages;
    final tableId = context.read<AppBloc>().state.deviceData!.table!.id;
    final customerCount = context.read<HomeBloc>().state.customerCount;

    final confirm = await showConfirmationDialog(
      context: context,
      message:
          'Proceed to start order with ${menuCart.length} menu '
          'items and ${packageCart.length} packages?',
      title: 'Confirm Order',
    );

    if (!context.mounted || !confirm) return;

    context.read<OrderBloc>().add(
      OrderEvent.started(
        tableId: tableId,
        inventoryItems: menuCart,
        packages: packageCart,
        customerCount: customerCount,
      ),
    );
  }
}
