import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/select/inventory_select_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/select/inventory_select_screen.dart';

@RoutePage()
class InventorySelectPage extends StatelessWidget implements AutoRouteWrapper {
  const InventorySelectPage({
    required this.initialItems,
    super.key,
    this.onSave,
  });

  final List<InventoryItem> initialItems;
  final void Function(List<InventoryItem>)? onSave;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventorySelectBloc, InventorySelectState>(
      listener: (context, state) {
        if (state.status == InventorySelectStatus.finished) {
          context.router.pop();
          onSave?.call(state.selectedItems);
        }
      },
      child: const InventorySelectScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => InventorySelectBloc(
        inventoryRepository: context.read(),
        initialItems: initialItems,
      )..add(const InventorySelectEvent.started()),
      child: this,
    );
  }
}
