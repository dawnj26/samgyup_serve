import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/app_logo_bounce.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: Dialog.fullscreen(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogoBounce(),
              if (message != null) ...[
                const SizedBox(height: 24),
                Text(
                  message!,
                  style: textTheme.titleMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
