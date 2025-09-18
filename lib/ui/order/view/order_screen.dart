import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';
import 'package:samgyup_serve/ui/order/view/tabs/menu_tab.dart';
import 'package:samgyup_serve/ui/order/view/tabs/package_tab.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<Widget> _tabs;
  late final List<Widget> _tabViews;

  @override
  void initState() {
    super.initState();

    // Exclude menu categories that are included in unli packages
    final categories = MenuCategory.values.where(
      (c) => c != MenuCategory.grilledMeats && c != MenuCategory.sideDishes,
    );

    _tabs = [
      const Tab(text: 'Unli Packages'),
      ...categories.map((c) => Tab(text: c.label)),
    ];
    _tabViews = [
      const PackageTab(),
      ...categories.map((c) => MenuTab(category: c)),
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
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
        ),
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
      onPressed: () {
        context.router.push(
          OrderCartRoute(
            onOrderStarted: () => _handleCheckout(context),
            onPointerDown: () => context.read<ActivityBloc>().add(
              const ActivityEvent.started(),
            ),
          ),
        );
      },
      child: Text('View Cart ($cartCount)'),
    );
  }

  Future<void> _handleCheckout(BuildContext context) async {
    final menuCart = context.read<OrderCartBloc>().state.menuItems;
    final packageCart = context.read<OrderCartBloc>().state.packages;
    final tableId = context.read<AppBloc>().state.deviceData!.table!.id;

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
        menuItems: menuCart,
        packages: packageCart,
      ),
    );
  }
}
