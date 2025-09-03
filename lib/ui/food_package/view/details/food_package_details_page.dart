import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/delete/food_package_delete_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/details/food_package_details_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/menu/food_package_menu_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/food_package/view/details/food_package_details_screen.dart';

@RoutePage()
class FoodPackageDetailsPage extends StatelessWidget
    implements AutoRouteWrapper {
  const FoodPackageDetailsPage({
    required this.package,
    super.key,
    this.onChange,
  });

  final FoodPackage package;
  final void Function()? onChange;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FoodPackageMenuBloc, FoodPackageMenuState>(
          listener: _handleMenuListener,
        ),
        BlocListener<FoodPackageDeleteBloc, FoodPackageDeleteState>(
          listener: _handleDeleteListener,
        ),
      ],
      child: PopScope(
        onPopInvokedWithResult: (didPop, _) {
          final deleteState = context.read<FoodPackageDeleteBloc>().state;
          final menuState = context.read<FoodPackageMenuBloc>().state;
          final isPackageChanged =
              deleteState is FoodPackageDeleteSuccess ||
              menuState is FoodPackageMenuSuccess;

          if (didPop && isPackageChanged) {
            onChange?.call();
          }
        },
        child: const FoodPackageDetailsScreen(),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FoodPackageDetailsBloc>(
          create: (context) => FoodPackageDetailsBloc(
            packageRepository: context.read(),
            menuRepository: context.read(),
            package: package,
          )..add(const FoodPackageDetailsEvent.started()),
        ),
        BlocProvider<FoodPackageMenuBloc>(
          create: (context) => FoodPackageMenuBloc(
            packageRepository: context.read(),
            packageId: package.id,
          ),
        ),
        BlocProvider<FoodPackageDeleteBloc>(
          create: (context) => FoodPackageDeleteBloc(
            packageRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }

  void _handleMenuListener(BuildContext context, FoodPackageMenuState state) {
    switch (state) {
      case FoodPackageMenuLoading():
        showLoadingDialog(context: context, message: 'Saving changes...');
      case FoodPackageMenuFailure(:final errorMessage):
        context.router.pop();
        showErrorDialog(
          context: context,
          message: errorMessage ?? 'An error occurred',
        );
      case FoodPackageMenuSuccess():
        context.router.pop();
        context.read<FoodPackageDetailsBloc>().add(
          const FoodPackageDetailsEvent.refreshed(),
        );
        showSnackBar(context, 'Changes saved successfully');
    }
  }

  void _handleDeleteListener(
    BuildContext context,
    FoodPackageDeleteState state,
  ) {
    switch (state) {
      case FoodPackageDeleteDeleting():
        showLoadingDialog(context: context, message: 'Deleting package...');
      case FoodPackageDeleteSuccess():
        context.router.pop();
        context.router.back();
        showSnackBar(context, 'Package deleted successfully');
      case FoodPackageDeleteFailure(:final errorMessage):
        context.router.pop();
        showErrorDialog(
          context: context,
          message: errorMessage,
        );
    }
  }
}
