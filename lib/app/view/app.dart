import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/l10n/l10n.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final DeviceRepository _deviceRepository;
  late final AppRouter _router;

  @override
  void initState() {
    _router = AppRouter();
    _authenticationRepository = AuthenticationRepository();
    _deviceRepository = DeviceRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _deviceRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: _authenticationRepository,
              deviceRepository: _deviceRepository,
            )..add(const AppEvent.started()),
          ),
        ],
        child: AppView(
          router: _router,
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({required this.router, super.key});
  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Samgyup Serve',
      routerConfig: router.config(),
      theme: ThemeData(
        colorSchemeSeed: Colors.red,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

@RoutePage()
class AppWrapperPage extends StatelessWidget {
  const AppWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: AutoRouter.declarative(
            routes: (_) {
              return [
                if (state is Authenticated)
                  const AdminRoute()
                else if (state is Unauthenticated)
                  const HomeShellRoute()
                else if (state is Unauthenticating)
                  LoadingRoute(message: 'Logging out...')
                else
                  const AppLoadingRoute(),
              ];
            },
          ),
        );
      },
    );
  }
}
