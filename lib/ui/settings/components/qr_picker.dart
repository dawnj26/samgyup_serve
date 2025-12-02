import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/image_picker.dart';

class QrPicker extends StatefulWidget {
  const QrPicker({super.key});

  @override
  State<QrPicker> createState() => _QrPickerState();
}

class _QrPickerState extends State<QrPicker> {
  PlatformFile? _image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick QR Code Image'),
      content: ImagePicker(
        onChange: (image) => setState(() => _image = image),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _image == null
              ? null
              : () => Navigator.of(context).pop(_image),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
