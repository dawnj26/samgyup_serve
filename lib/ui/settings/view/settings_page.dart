import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/settings/settings_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/settings/view/settings_screen.dart';
import 'package:settings_repository/settings_repository.dart';

@RoutePage()
class SettingsPage extends StatelessWidget implements AutoRouteWrapper {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state.status == LoadingStatus.loading) {
          showLoadingDialog(context: context, message: 'Updating settings...');
        }

        if (state.status == LoadingStatus.success) {
          context.router.pop();

          context.read<AppBloc>().add(
            AppEvent.settingsChanged(
              settings: state.settings,
            ),
          );

          showSnackBar(context, 'Settings updated successfully');
        }

        if (state.status == LoadingStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Something went wrong',
          );
        }
      },
      child: const SettingsScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final settings = context.read<AppBloc>().state.settings;
        final settingsRepository = context.read<SettingsRepository>();

        return SettingsBloc(
          settingsRepository: settingsRepository,
          initialSettings: settings,
        );
      },
      child: this,
    );
  }
}
