import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class SettingDetailsScreen extends StatefulWidget {
  const SettingDetailsScreen({
    required this.name,
    super.key,
    this.fileId,
    this.onSave,
  });

  final String name;
  final String? fileId;
  final void Function(File? file)? onSave;

  @override
  State<SettingDetailsScreen> createState() => _SettingDetailsScreenState();
}

class _SettingDetailsScreenState extends State<SettingDetailsScreen> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          TextButton(
            onPressed: () {
              context.router.pop();
              widget.onSave?.call(_selectedImage);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.fileId != null) ...[
                  AspectRatio(
                    aspectRatio: 1,
                    child: BucketImage(
                      fileId: widget.fileId,
                      loadingWidget: const CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                ImagePicker(
                  onChange: (image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
