import 'package:flutter/material.dart';

enum AppLogoIconVariant {
  color,
  blackAndWhite,
}

class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({
    this.size = 32,
    this.variant = AppLogoIconVariant.color,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final double size;
  final AppLogoIconVariant variant;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final assetPath = variant == AppLogoIconVariant.color
        ? 'assets/images/logo_icon.png'
        : 'assets/images/logo_icon_bw.png';

    return Padding(
      padding: padding,
      child: Image(
        image: AssetImage(assetPath),
        width: size,
      ),
    );
  }
}
