import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BucketImage extends StatelessWidget {
  const BucketImage({
    required this.fileId,
    super.key,
    this.loadingWidget,
    this.fit = BoxFit.cover,
  });

  final Widget? loadingWidget;
  final BoxFit fit;
  final String fileId;

  String getFileUrl(String fileId) {
    return AppwriteRepository.instance.getFileUrl(fileId);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: getFileUrl(fileId),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: fit,
    );
  }
}
