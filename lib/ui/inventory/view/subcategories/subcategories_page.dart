import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/subcategory/action/subcategory_action_bloc.dart';
import 'package:samgyup_serve/bloc/subcategory/subcategory_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/inventory/view/subcategories/subcategories_screen.dart';

@RoutePage()
class SubcategoriesPage extends StatelessWidget implements AutoRouteWrapper {
  const SubcategoriesPage({required this.category, super.key, this.onPop});

  final String category;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          final isDirty = context.read<SubcategoryBloc>().state.isDirty;
          if (isDirty) {
            onPop?.call();
          }
        }
      },
      child: BlocListener<SubcategoryActionBloc, SubcategoryActionState>(
        listener: (context, state) {
          final bloc = context.read<SubcategoryBloc>();

          if (state.status == LoadingStatus.loading) {
            final loadingMessage = switch (state.actionType) {
              SubcategoryActionType.create => 'Creating category...',
              SubcategoryActionType.remove => 'Removing category...',
            };
            showLoadingDialog(context: context, message: loadingMessage);
          }

          if (state.status == LoadingStatus.success) {
            bloc.add(
              const SubcategoryEvent.started(
                isChanged: true,
              ),
            );

            context.router.pop();

            final successMessage = switch (state.actionType) {
              SubcategoryActionType.create => 'Category created successfully',
              SubcategoryActionType.remove => 'Category removed successfully',
            };
            showSnackBar(
              context,
              successMessage,
            );
          }

          if (state.status == LoadingStatus.failure) {
            context.router.pop();
            showErrorDialog(
              context: context,
              message: state.errorMessage ?? 'Something went wrong.',
            );
          }
        },
        child: const SubcategoriesScreen(),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SubcategoryBloc(
            category: category,
            inventoryRepository: context.read<InventoryRepository>(),
          )..add(const SubcategoryEvent.started()),
        ),
        BlocProvider(
          create: (context) => SubcategoryActionBloc(
            inventoryRepository: context.read<InventoryRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
