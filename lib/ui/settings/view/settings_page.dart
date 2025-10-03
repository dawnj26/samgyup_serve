import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/settings/settings_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/settings/view/settings_screen.dart';

@RoutePage()
class SettingsPage extends StatelessWidget implements AutoRouteWrapper {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        final status = state.updateStatus;

        if (status == SettingUpdateStatus.loading) {
          showLoadingDialog(context: context, message: 'Updating setting...');
        }

        if (status == SettingUpdateStatus.success) {
          context.router.pop();
          showSnackBar(context, 'Setting updated successfully');
        }

        if (status == SettingUpdateStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'An unknown error occurred',
          );
        }
      },
      child: const SettingsScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsBloc(
        settingsRepository: context.read(),
      )..add(const SettingsEvent.started()),
      child: this,
    );
  }
}
