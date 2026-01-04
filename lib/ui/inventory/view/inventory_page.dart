import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/category/category_bloc.dart';
import 'package:samgyup_serve/bloc/category/form/category_form_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/inventory_screen.dart';

@RoutePage()
class InventoryPage extends StatelessWidget implements AutoRouteWrapper {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySyncing) {
              showLoadingDialog(
                context: context,
                message: 'Syncing inventory...',
              );
            }

            if (state is InventorySynced) {
              context.router.pop();
              showSnackBar(context, 'Synced successfully');
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
              showSnackBar(context, 'Cagtegory created successfully');
              context.read<CategoryBloc>().add(const CategoryEvent.started());
            }

            if (status == LoadingStatus.failure) {
              showErrorDialog(
                context: context,
                message: state.errorMessage ?? 'Something went wrong.',
              );
            }
          },
        ),
      ],
      child: const InventoryScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InventoryBloc(
            inventoryRepository: context.read(),
          )..add(const InventoryEvent.started()),
        ),
        BlocProvider(
          create: (context) => CategoryFormBloc(
            inventoryRepository: context.read(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CategoryBloc(inventoryRepository: context.read())
                ..add(const CategoryEvent.started()),
        ),
      ],
      child: this,
    );
  }
}
