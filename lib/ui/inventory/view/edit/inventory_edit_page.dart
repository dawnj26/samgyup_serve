import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/edit/inventory_edit_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/inventory/view/edit/inventory_edit_screen.dart';

@RoutePage()
class InventoryEditPage extends StatelessWidget implements AutoRouteWrapper {
  const InventoryEditPage({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryEditBloc, InventoryEditState>(
      listener: (context, state) {
        if (state is InventoryEditLoadingSubcategories) {
          showLoadingDialog(
            context: context,
            message: 'Loading subcategories...',
          );
        }

        if (state is InventoryEditLoadedSubcategories) {
          context.router.pop();
        }
      },
      child: InventoryEditScreen(item: item),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryEditBloc(
        inventoryRepository: context.read(),
        item: item,
      )..add(const InventoryEditEvent.started()),
      child: this,
    );
  }
}
