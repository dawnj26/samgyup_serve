import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/settings/settings_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.select(
      (SettingsBloc bloc) => bloc.state.settings,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Settings'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SettingLabel('Business'),
                  SettingTile(
                    name: 'Name',
                    value: settings.businessName,
                    onTap: () async {
                      final newName = await showTextInputDialog(
                        context: context,
                        title: 'Business Name',
                        initialValue: settings.businessName,
                      );

                      if (!context.mounted ||
                          newName == null ||
                          newName == settings.businessName) {
                        return;
                      }

                      context.read<SettingsBloc>().add(
                        SettingsEvent.nameChanged(newName),
                      );
                    },
                  ),
                  SettingTile(
                    name: 'Logo',
                    value: _formatValue(settings.businessLogo),
                    onTap: () async {
                      await context.router.push(
                        SettingDetailsRoute(
                          name: 'Business Logo',
                          fileId: settings.businessLogo,
                          onSave: (file) {
                            context.read<SettingsBloc>().add(
                              SettingsEvent.logoChanged(file),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const SettingLabel('Payment'),
                  SettingTile(
                    name: 'QR Code',
                    value: _formatValue(settings.qrCode),
                    onTap: () async {
                      await context.router.push(
                        SettingDetailsRoute(
                          name: 'QR Code',
                          fileId: settings.qrCode,
                          onSave: (file) {
                            context.read<SettingsBloc>().add(
                              SettingsEvent.qrChanged(file),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatValue(String? value) {
    if (value == null || value.isEmpty) {
      return 'Not set';
    }
    return 'Set';
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.name,
    required this.value,
    super.key,
    this.onTap,
  });

  final String name;
  final String value;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

class SettingLabel extends StatelessWidget {
  const SettingLabel(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Text(data, style: textTheme.labelLarge),
    );
  }
}
