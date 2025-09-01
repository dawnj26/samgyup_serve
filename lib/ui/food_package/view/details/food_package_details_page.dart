import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/food_package/details/food_package_details_bloc.dart';
import 'package:samgyup_serve/ui/food_package/view/details/food_package_details_screen.dart';

@RoutePage()
class FoodPackageDetailsPage extends StatelessWidget implements AutoRouteWrapper {
  const FoodPackageDetailsPage({required this.package, super.key});

  final FoodPackage package;

  @override
  Widget build(BuildContext context) {
    return const FoodPackageDetailsScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<FoodPackageDetailsBloc>(
      create: (context) => FoodPackageDetailsBloc(
        packageRepository: context.read<PackageRepository>(),
        package: package,
      ),
      child: this,
    );
  }
}
