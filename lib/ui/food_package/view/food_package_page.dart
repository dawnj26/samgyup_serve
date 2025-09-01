import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/food_package_bloc.dart';
import 'package:samgyup_serve/ui/food_package/view/food_package_screen.dart';

@RoutePage()
class FoodPackagePage extends StatelessWidget implements AutoRouteWrapper {
  const FoodPackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodPackageScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<FoodPackageBloc>(
      create: (context) => FoodPackageBloc(
        packageRepository: context.read(),
      )..add(const FoodPackageEvent.started()),
      child: this,
    );
  }
}
