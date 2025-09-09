import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuImage extends StatelessWidget {
  const MenuImage({required this.fileId, super.key});

  final String fileId;

  @override
  Widget build(BuildContext context) {
    return BucketImage(
      fileId: fileId,
    );
  }
}
