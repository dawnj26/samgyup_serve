import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/app/app.dart';
import 'package:samgyup_serve/ui/admin/admin.dart';
import 'package:samgyup_serve/ui/components/screens/app_loading_screen.dart';
import 'package:samgyup_serve/ui/components/screens/loading_screen.dart';
import 'package:samgyup_serve/ui/dashboard/dashboard.dart';
import 'package:samgyup_serve/ui/food_package/food_package.dart';
import 'package:samgyup_serve/ui/home/home.dart';
import 'package:samgyup_serve/ui/inventory/inventory.dart';
import 'package:samgyup_serve/ui/login/login.dart';
import 'package:samgyup_serve/ui/management/management.dart';
import 'package:samgyup_serve/ui/menu/menu.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: AppWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(
          path: 'home',
          page: HomeShellRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(path: 'login', page: LoginRoute.page),
          ],
        ),
        AutoRoute(
          path: 'admin',
          page: AdminShellRoute.page,
          children: [
            AutoRoute(
              page: AdminRoute.page,
              children: [
                AutoRoute(page: DashboardRoute.page, initial: true),
                AutoRoute(page: ManagementRoute.page),
              ],
              initial: true,
            ),
            AutoRoute(
              page: InventoryShellRoute.page,
              children: [
                AutoRoute(page: InventoryRoute.page, initial: true),
                AutoRoute(page: InventoryAddRoute.page),
                AutoRoute(page: InventoryStatusListRoute.page),
                AutoRoute(page: InventoryCategoryListRoute.page),
                AutoRoute(page: InventoryEditRoute.page),
              ],
            ),
            AutoRoute(
              page: MenuShellRoute.page,
              children: [
                AutoRoute(page: MenuRoute.page, initial: true),
                AutoRoute(
                  page: MenuCreateRoute.page,
                  children: [
                    AutoRoute(page: MenuFormRoute.page, initial: true),
                    AutoRoute(page: MenuIngredientRoute.page),
                  ],
                ),
                AutoRoute(page: IngredientSelectRoute.page),
                AutoRoute(page: MenuDetailsRoute.page),
                AutoRoute(page: MenuEditRoute.page),
              ],
            ),
            AutoRoute(
              page: FoodPackageShellRoute.page,
              children: [
                AutoRoute(page: FoodPackageRoute.page, initial: true),
              ],
            ),
          ],
        ),
        CustomRoute<void>(
          page: LoadingRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeft,
        ),
        AutoRoute(page: AppLoadingRoute.page),
      ],
    ),
  ];
}
