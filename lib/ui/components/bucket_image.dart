import 'dart:developer';
import 'dart:typed_data';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:flutter/material.dart';

class BucketImage extends StatelessWidget {
  const BucketImage({
    required this.fileId,
    super.key,
    this.loadingWidget,
    this.fit = BoxFit.cover,
  });

  final String fileId;
  final Widget? loadingWidget;
  final BoxFit fit;

  Future<Uint8List> _loadImage() {
    return AppwriteRepository.instance.getImageView(fileId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadImage(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ??
              const Center(
                child: CircularProgressIndicator(),
              );
        }
        if (snapshot.hasError) {
          log(snapshot.error.toString());
          return const Center(child: Icon(Icons.error));
        }
        if (!snapshot.hasData) {
          return const Center(child: Icon(Icons.image_not_supported));
        }

        return Image.memory(
          snapshot.data!,
          fit: fit,
        );
      },
    );
  }
}
