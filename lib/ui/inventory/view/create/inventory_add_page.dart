import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/inventory/view/create/inventory_add_screen.dart';

@RoutePage()
class InventoryAddPage extends StatelessWidget implements AutoRouteWrapper {
  const InventoryAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryCreateBloc, InventoryCreateState>(
      listener: (context, state) {
        if (state is InventoryCreateLoadingSubcategories) {
          showLoadingDialog(
            context: context,
            message: 'Loading subcategories...',
          );
        }

        if (state is InventoryCreateLoadedSubcategories) {
          context.router.pop();
        }
      },
      child: const InventoryAddScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryCreateBloc(
        inventoryRepository: context.read(),
      ),
      child: this,
    );
  }
}
