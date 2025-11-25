import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/edit/food_package_edit_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/food_package/view/edit/food_package_edit_screen.dart';

@RoutePage()
class FoodPackageEditPage extends StatelessWidget implements AutoRouteWrapper {
  const FoodPackageEditPage({required this.package, super.key, this.onChanged});

  final FoodPackageItem package;
  final void Function(FoodPackageItem package)? onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodPackageEditBloc, FoodPackageEditState>(
      listener: (context, state) {
        switch (state) {
          case FoodPackageEditNoChanges():
            context.router.pop();
          case FoodPackageEditLoading():
            showLoadingDialog(context: context, message: 'Saving changes...');
          case FoodPackageEditSuccess(:final package):
            onChanged?.call(package);
            context.router.popUntilRouteWithName(FoodPackageDetailsRoute.name);
            showSnackBar(context, 'Package updated successfully');
          case FoodPackageEditFailure(:final errorMessage):
            context.router.pop();
            showErrorDialog(
              context: context,
              message: errorMessage ?? 'An unknown error occurred',
            );
        }
      },
      child: FoodPackageEditScreen(
        package: package,
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodPackageEditBloc(
        package: package,
        packageRepository: context.read<PackageRepository>(),
      ),
      child: this,
    );
  }
}
