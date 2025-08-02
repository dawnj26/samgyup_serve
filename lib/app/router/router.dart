import 'package:auto_route/auto_route.dart';
import 'package:samgyup_serve/admin/admin.dart';
import 'package:samgyup_serve/app/app.dart';
import 'package:samgyup_serve/home/home.dart';
import 'package:samgyup_serve/login/login.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AppWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(
          page: HomeShellRoute.page,
          children: [
            AutoRoute(page: HomeRoute.page, initial: true),
            AutoRoute(page: LoginRoute.page),
          ],
        ),
        AutoRoute(
          page: AdminShellRoute.page,
          children: [
            AutoRoute(page: AdminRoute.page, initial: true),
          ],
        ),
      ],
    ),
  ];
}
