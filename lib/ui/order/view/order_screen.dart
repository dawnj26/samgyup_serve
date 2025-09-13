import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
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
    _tabs = [
      const Tab(text: 'Unli Packages'),
      ...MenuCategory.values.map((c) => Tab(text: c.label)),
    ];
    _tabViews = [
      const PackageTab(),
      ...MenuCategory.values.map((c) => MenuTab(category: c)),
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
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.status == OrderStatus.loading ||
              state.status == OrderStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrderStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: _tabViews,
          );
        },
      ),
    );
  }
}
