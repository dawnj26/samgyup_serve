import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/details/food_package_details_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/menu/food_package_menu_bloc.dart';
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
    return BlocListener<FoodPackageMenuBloc, FoodPackageMenuState>(
      listener: (context, state) {
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
            onChange?.call();
        }
      },
      child: const FoodPackageDetailsScreen(),
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
      ],
      child: this,
    );
  }
}
