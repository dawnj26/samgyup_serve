import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/ui/components/bucket_image.dart';

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
    this.useFallback = false,
  });

  final double size;
  final AppLogoIconVariant variant;
  final EdgeInsetsGeometry padding;
  final bool useFallback;

  @override
  Widget build(BuildContext context) {
    final businessLogo = context.select(
      (AppBloc bloc) => bloc.state.settings.businessLogo,
    );

    if (businessLogo != null && !useFallback) {
      return Padding(
        padding: padding,
        child: BucketImage(
          fileId: businessLogo,
          size: size,
        ),
      );
    }

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
