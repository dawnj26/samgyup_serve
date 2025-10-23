import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/screens/loading_screen.dart';

class ReservationCancelScreen extends StatelessWidget {
  const ReservationCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, res) {
        if (didPop) {
          return;
        }

        context.router.pop();
      },
      canPop: false,
      child: const LoadingScreen(
        message: 'Cancelling reservation please wait...',
      ),
    );
  }
}
