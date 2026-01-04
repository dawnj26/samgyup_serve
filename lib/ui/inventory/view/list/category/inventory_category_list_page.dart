import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/category/delete/category_delete_bloc.dart';
import 'package:samgyup_serve/bloc/category/form/category_form_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/category/inventory_category_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/list/category/inventory_category_list_screen.dart';

@RoutePage()
class InventoryCategoryListPage extends StatelessWidget
    implements AutoRouteWrapper {
  const InventoryCategoryListPage({
    required this.category,
    super.key,
    this.categoryId,
  });

  final String category;
  final String? categoryId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoryDeleteBloc, CategoryDeleteState>(
          listener: (context, state) {
            final status = state.status;

            if (status == LoadingStatus.loading) {
              showLoadingDialog(
                context: context,
                message: 'Deleting category...',
              );
            }

            if (status == LoadingStatus.success) {
              context.router.pop();
              context.router.pop(true);
              showSnackBar(context, 'Category deleted successfully');
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
        BlocListener<CategoryFormBloc, CategoryFormState>(
          listener: (context, state) {
            final status = state.status;

            if (status == LoadingStatus.loading) {
              showLoadingDialog(context: context, message: 'Processing...');
            }

            if (status == LoadingStatus.success) {
              context.router.pop();
              showSnackBar(context, 'Category updated successfully');
              context.read<InventoryCategoryBloc>().add(
                const InventoryCategoryEvent.reload(),
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
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          final triggerReload =
              context.read<InventoryDeleteBloc>().state
                  is InventoryDeleteSuccess ||
              context.read<CategoryDeleteBloc>().state.status ==
                  LoadingStatus.success ||
              context.read<CategoryFormBloc>().state.status ==
                  LoadingStatus.success;
          log('Pop invoked with result: $triggerReload $didPop');

          context.router.pop(triggerReload);
        },
        child: const InventoryCategoryListScreen(),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              InventoryCategoryBloc(
                inventoryRepository: context.read<InventoryRepository>(),
                category: category,
                categoryId: categoryId,
              )..add(
                const InventoryCategoryEvent.started(),
              ),
        ),
        BlocProvider(
          create: (context) => InventoryDeleteBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoryDeleteBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoryFormBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
