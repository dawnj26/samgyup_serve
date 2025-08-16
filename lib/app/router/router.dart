import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/app/app.dart';
import 'package:samgyup_serve/components/screens/app_loading_screen.dart';
import 'package:samgyup_serve/components/screens/loading_screen.dart';
import 'package:samgyup_serve/ui/admin/admin.dart';
import 'package:samgyup_serve/ui/dashboard/dashboard.dart';
import 'package:samgyup_serve/ui/home/home.dart';
import 'package:samgyup_serve/ui/login/login.dart';
import 'package:samgyup_serve/ui/management/management.dart';

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
          page: AdminRoute.page,
          children: [
            AutoRoute(page: DashboardRoute.page, initial: true),
            AutoRoute(page: ManagementRoute.page),
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
