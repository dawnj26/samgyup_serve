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
class AppWrapperPage extends StatelessWidget implements AutoRouteWrapper {
  const AppWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        final authStatus = state.authStatus;
        final deviceStatus = state.deviceStatus;
        final appStatus = state.status;

        return PopScope(
          canPop: false,
          child: AutoRouter.declarative(
            routes: (_) {
              if (appStatus == AppStatus.loading ||
                  appStatus == AppStatus.initial ||
                  authStatus == AuthStatus.unauthenticated ||
                  authStatus == AuthStatus.initial) {
                return [
                  const AppLoadingRoute(),
                ];
              }

              final home = deviceStatus == DeviceStatus.unknown
                  ? const LoginRoute()
                  : const HomeRoute();

              return [
                if (authStatus == AuthStatus.guest)
                  home
                else if (authStatus == AuthStatus.unauthenticating)
                  LoadingRoute(message: 'Logging out...')
                else
                  const AdminRoute(),
              ];
            },
          ),
        );
      },
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state.status == AppStatus.failure) {
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'An unknown error occurred',
          );
        }
      },
      child: this,
    );
  }
}
