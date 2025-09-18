import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/select/menu_select_bloc.dart';
import 'package:samgyup_serve/ui/food_package/view/menu/menu_select_screen.dart';

@RoutePage()
class MenuSelectPage extends StatelessWidget implements AutoRouteWrapper {
  const MenuSelectPage({
    required this.initialItems,
    super.key,
    this.onSave,
    this.allowedCategories = const [],
    this.menuIds,
  });

  final void Function(List<MenuItem> items)? onSave;
  final List<MenuCategory> allowedCategories;
  final List<MenuItem> initialItems;
  final List<String>? menuIds;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuSelectBloc, MenuSelectState>(
      listener: (context, state) {
        switch (state) {
          case MenuSelectDone(:final selectedItems):
            onSave?.call(selectedItems);
            context.router.pop();
        }
      },
      child: const MenuSelectScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<MenuSelectBloc>(
      create: (context) => MenuSelectBloc(
        initialSelectedItems: initialItems,
        allowedCategories: allowedCategories,
        menuRepository: context.read(),
      )..add(const MenuSelectEvent.started()),
      child: this,
    );
  }
}
