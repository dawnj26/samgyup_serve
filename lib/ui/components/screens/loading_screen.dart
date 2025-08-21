import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/app_logo_bounce.dart';

@RoutePage()
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogoBounce(),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
