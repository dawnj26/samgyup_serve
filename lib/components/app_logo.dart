import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 64, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage('assets/images/logo.png'),
      width: size,
    );
  }
}
