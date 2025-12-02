import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/settings/view/details/setting_details_screen.dart';

@RoutePage()
class SettingDetailsPage extends StatelessWidget {
  const SettingDetailsPage({
    required this.name,
    super.key,
    this.fileId,
    this.onSave,
  });

  final String name;
  final String? fileId;
  final void Function(PlatformFile? file)? onSave;

  @override
  Widget build(BuildContext context) {
    return SettingDetailsScreen(
      name: name,
      fileId: fileId,
      onSave: onSave,
    );
  }
}
