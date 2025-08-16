import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/app_logo_icon.dart';

@RoutePage()
class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: AppLogoIcon(
              size: 100,
            ),
          ),
        ),
      ),
    );
  }
}
