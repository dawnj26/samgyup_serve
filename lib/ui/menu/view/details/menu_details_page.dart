import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/details/menu_details_bloc.dart';
import 'package:samgyup_serve/ui/menu/view/details/menu_details_screen.dart';

@RoutePage()
class MenuDetailsPage extends StatelessWidget implements AutoRouteWrapper {
  const MenuDetailsPage({required this.menuItem, super.key});

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    return const MenuDetailsScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuDetailsBloc(
        menuRepository: context.read<MenuRepository>(),
        menuItem: menuItem,
      )..add(const MenuDetailsEvent.started()),
      child: this,
    );
  }
}
