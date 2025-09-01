import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_repository/package_repository.dart';

@RoutePage()
class FoodPackageShellPage extends StatelessWidget implements AutoRouteWrapper {
  const FoodPackageShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PackageRepository(),
      child: this,
    );
  }
}
