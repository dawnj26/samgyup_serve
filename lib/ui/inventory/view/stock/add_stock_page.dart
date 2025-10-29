import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/stock/inventory_stock_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/stock/add_stock_screen.dart';

@RoutePage()
class AddStockPage extends StatelessWidget implements AutoRouteWrapper {
  const AddStockPage({required this.item, super.key, this.onStockAdded});

  final InventoryItem item;
  final void Function()? onStockAdded;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryStockBloc, InventoryStockState>(
      listener: (context, state) {
        final status = state.status;

        if (status == LoadingStatus.loading) {
          showLoadingDialog(context: context);
        }

        if (status == LoadingStatus.success) {
          context.router.pop();
          goToPreviousRoute(context);
          onStockAdded?.call();

          showSnackBar(context, 'Stock added successfully');
        }

        if (status == LoadingStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'An unknown error occurred.',
          );
        }
      },
      child: const AddStockScreen(),
    );
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
