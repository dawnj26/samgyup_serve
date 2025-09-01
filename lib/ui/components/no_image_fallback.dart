import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';

class NoImageFallback extends StatelessWidget {
  const NoImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.grey.shade50,
      child: const Center(
        child: AppLogoIcon(
          variant: AppLogoIconVariant.blackAndWhite,
          size: 64,
        ),
      ),
    );
  }
}
