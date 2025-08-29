import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/edit/menu_edit_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/menu/view/edit/menu_edit_screen.dart';

@RoutePage()
class MenuEditPage extends StatelessWidget implements AutoRouteWrapper {
  const MenuEditPage({required this.menuItem, super.key, this.onChange});

  final MenuItem menuItem;
  final void Function({required bool needsReload})? onChange;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuEditBloc, MenuEditState>(
      listener: (context, state) {
        switch (state) {
          case MenuEditSubmitting():
            showLoadingDialog(
              context: context,
              message: 'Saving menu item...',
            );
          case MenuEditSuccess():
            context.router.popUntilRouteWithName(MenuDetailsRoute.name);
            onChange?.call(needsReload: true);
            showSnackBar(context, 'Menu item saved successfully');
          case MenuEditFailure(:final errorMessage):
            context.router.pop();
            showErrorDialog(
              context: context,
              message: errorMessage ?? 'An unknown error occurred',
            );
          case MenuEditPure():
            context.router.popUntilRouteWithName(MenuDetailsRoute.name);
        }
      },
      child: const MenuEditScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuEditBloc(
        menuRepository: context.read<MenuRepository>(),
        menuItem: menuItem,
      ),
      child: this,
    );
  }
}
