import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/bucket_image.dart';

class PackageImage extends StatelessWidget {
  const PackageImage({required this.fileId, super.key});

  final String fileId;

  @override
  Widget build(BuildContext context) {
    return BucketImage(
      fileId: fileId,
    );
  }
}
