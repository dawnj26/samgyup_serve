import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/batch/delete/batch_delete_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/details/inventory_details_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/details/inventory_details_screen.dart';

@RoutePage()
class InventoryDetailsPage extends StatelessWidget implements AutoRouteWrapper {
  const InventoryDetailsPage({required this.item, super.key, this.onChanged});

  final InventoryItem item;
  final void Function()? onChanged;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BatchDeleteBloc, BatchDeleteState>(
          listener: (context, state) {
            final status = state.status;

            if (status == LoadingStatus.loading) {
              showLoadingDialog(context: context, message: 'Removing batch...');
            }

            if (status == LoadingStatus.success) {
              context.router.pop();
              showSnackBar(context, 'Batch deleted successfully');
              context.read<InventoryDetailsBloc>().add(
                const InventoryDetailsEvent.batchRefreshed(),
              );
            }

            if (status == LoadingStatus.failure) {
              context.router.pop();
              showErrorDialog(
                context: context,
                message: state.errorMessage ?? 'Something went wrong.',
              );
            }
          },
        ),
        BlocListener<InventoryDeleteBloc, InventoryDeleteState>(
          listener: _handleListener,
        ),
      ],
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          final isDirty = context.read<InventoryDetailsBloc>().state.isDirty;

          if (didPop && isDirty) {
            onChanged?.call();
          }
        },
        child: const InventoryDetailsScreen(),
      ),
    );
  }

  void _handleListener(BuildContext context, InventoryDeleteState state) {
    switch (state) {
      case InventoryDeleteLoading():
        showLoadingDialog(context: context);
      case InventoryDeleteSuccess():
        onChanged?.call();
        context.router.pop();
        goToPreviousRoute(context);
        showSnackBar(context, 'Item deleted successfully.');
    }
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InventoryDetailsBloc(
            item: item,
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => InventoryDeleteBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => BatchDeleteBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
