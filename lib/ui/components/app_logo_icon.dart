import 'package:flutter/material.dart';

enum AppLogoIconVariant {
  color,
  blackAndWhite,
}

class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({
    this.size = 32,
    this.variant = AppLogoIconVariant.color,
    super.key,
  });
  final double size;
  final AppLogoIconVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == AppLogoIconVariant.blackAndWhite) {
      return Image(
        image: const AssetImage('assets/images/logo_icon_bw.png'),
        width: size,
      );
    }

    return Image(
      image: const AssetImage('assets/images/logo_icon.png'),
      width: size,
    );
  }
}
