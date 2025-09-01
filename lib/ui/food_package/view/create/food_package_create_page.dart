import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/create/food_package_create_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/food_package/view/create/food_package_create_screen.dart';

@RoutePage()
class FoodPackageCreatePage extends StatelessWidget
    implements AutoRouteWrapper {
  const FoodPackageCreatePage({super.key, this.onCreated});

  final void Function(FoodPackage package)? onCreated;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodPackageCreateBloc, FoodPackageCreateState>(
      listener: (context, state) {
        switch (state) {
          case FoodPackageCreateCreating():
            showLoadingDialog(context: context, message: 'Creating package...');
          case FoodPackageCreateSuccess(:final foodPackage):
            context.router.popUntilRouteWithName(FoodPackageRoute.name);
            showSnackBar(context, 'Package created successfully');
            onCreated?.call(foodPackage);
          case FoodPackageCreateFailure(:final errorMessage):
            context.router.pop();
            showErrorDialog(context: context, message: errorMessage);
        }
      },
      child: const FoodPackageCreateScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<FoodPackageCreateBloc>(
      create: (context) => FoodPackageCreateBloc(
        packageRepository: context.read(),
      ),
      child: this,
    );
  }
}
