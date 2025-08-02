import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/app/bloc/app_bloc.dart';
import 'package:samgyup_serve/app/router/router.dart';
import 'package:samgyup_serve/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationRepository _authenticationRepository;
  late final AppRouter _router;

  @override
  void initState() {
    _router = AppRouter();
    _authenticationRepository = AuthenticationRepository();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppBloc(authenticationRepository: _authenticationRepository),
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
                  const AdminShellRoute()
                else
                  const HomeShellRoute(),
              ];
            },
          ),
        );
      },
    );
  }
}
