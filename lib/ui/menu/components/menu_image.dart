import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuImage extends StatelessWidget {
  const MenuImage({required this.imageFileName, super.key});

  final String imageFileName;

  @override
  Widget build(BuildContext context) {
    return BucketImage(
      onLoad: () {
        return AppwriteRepository.instance.getFile(imageFileName);
      },
    );
  }
}
