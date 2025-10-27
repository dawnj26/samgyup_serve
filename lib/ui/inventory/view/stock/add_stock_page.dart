import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/stock/inventory_stock_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/stock/add_stock_screen.dart';

@RoutePage()
class AddStockPage extends StatelessWidget implements AutoRouteWrapper {
  const AddStockPage({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return const AddStockScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryStockBloc(
        inventoryRepository: context.read<InventoryRepository>(),
        item: item,
      ),
      child: this,
    );
  }
}
