import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';

@RoutePage()
class MenuPackageWrapperPage extends StatelessWidget
    implements AutoRouteWrapper {
  const MenuPackageWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MenuRepository(),
      child: this,
    );
  }
}
