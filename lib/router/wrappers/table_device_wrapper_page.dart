import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_repository/table_repository.dart';

@RoutePage()
class TableDeviceWrapperPage extends StatelessWidget
    implements AutoRouteWrapper {
  const TableDeviceWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TableRepository(),
      child: this,
    );
  }
}
