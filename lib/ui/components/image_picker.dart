import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({
    super.key,
    this.onChange,
    this.initialFileName,
    this.hintText = 'Select an image',
    this.labelText = 'Image',
    this.enabled = true,
  });

  final void Function(File? image)? onChange;
  final String? initialFileName;
  final String? hintText;
  final String? labelText;
  final bool enabled;

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialFileName != null) {
      _controller.text = widget.initialFileName!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      setState(() {
        _controller.text = result.files.single.name;
      });

      widget.onChange?.call(file);
    }
  }

  void _clearSelection() {
    setState(_controller.clear);
    widget.onChange?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      enabled: widget.enabled,
      onTap: widget.enabled ? _pickImage : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.text.isNotEmpty && widget.enabled)
              IconButton(
                onPressed: _clearSelection,
                icon: const Icon(Icons.clear),
                tooltip: 'Clear selection',
              ),
            IconButton(
              onPressed: widget.enabled ? _pickImage : null,
              icon: const Icon(Icons.file_upload_outlined),
              tooltip: 'Select image',
            ),
          ],
        ),
        prefixIcon: const Icon(Icons.photo_library_outlined),
      ),
    );
  }
}
