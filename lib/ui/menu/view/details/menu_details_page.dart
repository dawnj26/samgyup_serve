import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/ingredient/edit/ingredient_edit_bloc.dart';
import 'package:samgyup_serve/bloc/menu/delete/menu_delete_bloc.dart';
import 'package:samgyup_serve/bloc/menu/details/menu_details_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/menu/view/details/menu_details_screen.dart';

@RoutePage()
class MenuDetailsPage extends StatelessWidget implements AutoRouteWrapper {
  const MenuDetailsPage({required this.menuItem, super.key, this.onChange});

  final MenuItem menuItem;
  final void Function({required bool needsReload})? onChange;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MenuDeleteBloc, MenuDeleteState>(
          listener: (context, state) {
            switch (state) {
              case MenuDeleteDeleting():
                showLoadingDialog(
                  context: context,
                  message: 'Deleting menu item...',
                );
              case MenuDeleteSuccess():
                context.router.popUntilRouteWithName(MenuRoute.name);
                showSnackBar(context, 'Menu item deleted successfully');
                onChange?.call(needsReload: true);
              case MenuDeleteError(:final message):
                context.router.pop();
                showErrorDialog(context: context, message: message);
            }
          },
        ),
        BlocListener<IngredientEditBloc, IngredientEditState>(
          listener: (context, state) {
            switch (state) {
              case IngredientEditSaving():
                showLoadingDialog(
                  context: context,
                  message: 'Saving ingredients...',
                );
              case IngredientEditSaved():
                context.router.pop();
                context.read<MenuDetailsBloc>().add(
                  const MenuDetailsEvent.reloaded(),
                );
                showSnackBar(context, 'Ingredients saved successfully');
              case IngredientEditError(:final message):
                context.router.pop();
                showErrorDialog(context: context, message: message);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuDetailsBloc(
            menuRepository: context.read<MenuRepository>(),
            menuItem: menuItem,
          )..add(const MenuDetailsEvent.started()),
        ),
        BlocProvider(
          create: (context) => MenuDeleteBloc(
            menuRepository: context.read<MenuRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => IngredientEditBloc(
            menuRepository: context.read<MenuRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
