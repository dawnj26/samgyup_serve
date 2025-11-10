import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';

class BucketImage extends StatelessWidget {
  const BucketImage({
    required this.fileId,
    super.key,
    this.loadingWidget,
    this.fit = BoxFit.cover,
    this.size,
  });

  final Widget? loadingWidget;
  final BoxFit fit;
  final String? fileId;
  final double? size;

  String getFileUrl(String fileId) {
    return AppwriteRepository.instance.getFileUrl(fileId);
  }

  @override
  Widget build(BuildContext context) {
    if (fileId == null) {
      return ColoredBox(
        color: Colors.grey.shade200,
        child: const AppLogoIcon(
          variant: AppLogoIconVariant.blackAndWhite,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: getFileUrl(fileId!),
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child:
              loadingWidget ??
              CircularProgressIndicator(value: progress.progress),
        );
      },
      width: size,
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: fit,
    );
  }
}
