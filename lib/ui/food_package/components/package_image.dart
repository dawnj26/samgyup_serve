import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/bucket_image.dart';

class PackageImage extends StatelessWidget {
  const PackageImage({required this.filename, super.key});

  final String filename;

  @override
  Widget build(BuildContext context) {
    return BucketImage(
      onLoad: () {
        return AppwriteRepository.instance.getFile(filename);
      },
    );
  }
}
