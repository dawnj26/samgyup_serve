import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return AutoTabsScaffold(
      appBarBuilder: (context, tabsRouter) {
        return AppBar(
          title: const AppLogoIcon(
            size: 40,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                appBloc.add(const AppEvent.logout());
              },
            ),
          ],
        );
      },
      routes: const [
        DashboardRoute(),
        EventRoute(),
        ManagementRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return NavigationBar(
          selectedIndex: tabsRouter.activeIndex,
          onDestinationSelected: tabsRouter.setActiveIndex,
          destinations: const [
            NavigationDestination(
              label: 'Home',
              icon: Icon(Icons.space_dashboard_outlined),
              selectedIcon: Icon(Icons.space_dashboard),
            ),
            NavigationDestination(
              label: 'Events',
              icon: Icon(Icons.event_outlined),
              selectedIcon: Icon(Icons.event),
            ),
            NavigationDestination(
              label: 'Management',
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}
