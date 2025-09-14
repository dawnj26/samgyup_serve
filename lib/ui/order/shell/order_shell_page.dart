import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
import 'package:table_repository/table_repository.dart';

@RoutePage()
class OrderShellPage extends AutoRouter implements AutoRouteWrapper {
  const OrderShellPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MenuRepository(),
        ),
        RepositoryProvider(
          create: (context) => PackageRepository(),
        ),
        RepositoryProvider(
          create: (context) => TableRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrderBloc(
              tableRepository: context.read<TableRepository>(),
              tableId: context.read<AppBloc>().state.device!.tableId!,
            )..add(const OrderEvent.started()),
          ),
          BlocProvider(
            create: (context) => OrderCartBloc(),
          ),
        ],
        child: this,
      ),
    );
  }
}
