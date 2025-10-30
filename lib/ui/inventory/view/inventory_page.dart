import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/inventory_screen.dart';

@RoutePage()
class InventoryPage extends StatelessWidget implements AutoRouteWrapper {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is InventorySyncing) {
          showLoadingDialog(context: context, message: 'Syncing inventory...');
        }

        if (state is InventorySynced) {
          context.router.pop();
          showSnackBar(context, 'Synced successfully');
        }
      },
      child: const InventoryScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(
        inventoryRepository: context.read(),
      )..add(const InventoryEvent.started()),
      child: this,
    );
  }
}
