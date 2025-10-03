import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/bucket_image.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({required this.fileId, super.key});

  final String fileId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Center(
            child: BucketImage(
              fileId: fileId,
              fit: BoxFit.contain,
              loadingWidget: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Close button at top right
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
