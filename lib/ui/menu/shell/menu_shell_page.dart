import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';

@RoutePage()
class MenuShellPage extends StatelessWidget implements AutoRouteWrapper {
  const MenuShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: context.read<MenuRepository>(),
        ),
        RepositoryProvider(
          create: (context) => InventoryRepository(),
        ),
      ],
      child: this,
    );
  }
}
