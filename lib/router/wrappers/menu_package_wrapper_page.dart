import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';

@RoutePage()
class InventoryPackageWrapperPage extends StatelessWidget
    implements AutoRouteWrapper {
  const InventoryPackageWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => InventoryRepository(),
      child: this,
    );
  }
}
