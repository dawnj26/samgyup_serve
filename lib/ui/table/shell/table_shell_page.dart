import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';

@RoutePage()
class TableShellPage extends StatelessWidget {
  const TableShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => OrderRepository(),
        ),
        RepositoryProvider(
          create: (context) => PackageRepository(),
        ),
        RepositoryProvider(
          create: (context) => MenuRepository(),
        ),
      ],
      child: const AutoRouter(),
    );
  }
}
