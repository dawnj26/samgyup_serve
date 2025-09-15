import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrderCartBloc(),
          ),
        ],
        child: this,
      ),
    );
  }
}
