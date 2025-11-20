import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.size = 64, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    final businessLogo = context.select(
      (AppBloc bloc) => bloc.state.settings.businessLogo,
    );

    if (businessLogo != null) {
      return BucketImage(
        fileId: businessLogo,
        size: size,
      );
    }

    return Image(
      image: const AssetImage('assets/images/logo.png'),
      width: size,
    );
  }
}
