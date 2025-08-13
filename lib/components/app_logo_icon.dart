import 'package:flutter/material.dart';

class AppLogoIcon extends StatelessWidget {
  const AppLogoIcon({this.size = 32, super.key});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage('assets/images/logo_icon.png'),
      width: size,
    );
  }
}
