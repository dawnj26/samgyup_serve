import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

class BucketImage extends StatelessWidget {
  const BucketImage({
    required this.onLoad,
    super.key,
    this.loadingWidget,
    this.fit = BoxFit.cover,
  });

  final Widget? loadingWidget;
  final BoxFit fit;
  final Future<File> Function() onLoad;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: onLoad(),
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

        return Image.file(
          snapshot.data!,
          fit: fit,
        );
      },
    );
  }
}
