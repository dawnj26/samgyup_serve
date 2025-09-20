import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/components/screens/loading_screen.dart';

class PaymentOrderScreen extends StatelessWidget {
  const PaymentOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(
      message: "We've notified the staff. Please wait...",
    );
  }
}
