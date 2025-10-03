import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/settings/settings_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/settings/components/qr_picker.dart';
import 'package:settings_repository/settings_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          switch (state.status) {
            case SettingsStatus.loading || SettingsStatus.initial:
              return const Center(child: CircularProgressIndicator());
            case SettingsStatus.success:
              return ListView.builder(
                itemCount: state.settings.length,
                itemBuilder: (context, index) {
                  final setting = state.settings[index];
                  return ListTile(
                    title: Text(setting.title),
                    subtitle: Text(setting.value ?? 'Not set'),
                    onTap: () => _handleTap(context, setting),
                    trailing: _Trailing(setting: setting),
                  );
                },
              );
            case SettingsStatus.failure:
              return Center(
                child: Text(
                  state.errorMessage ?? 'An unknown error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
          }
        },
      ),
    );
  }

  Future<void> _handleTap(BuildContext context, Setting setting) async {
    if (setting.name == 'qr_code') {
      final result = await showDialog<File?>(
        context: context,
        builder: (context) => const QrPicker(),
      );
      if (!context.mounted || result == null) return;

      context.read<SettingsBloc>().add(
        SettingsEvent.qrCodeUpdated(result, setting),
      );
    }
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.setting});

  final Setting setting;

  @override
  Widget build(BuildContext context) {
    if (setting.name == 'qr_code' && setting.value != null) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: BucketImage(fileId: setting.value),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
