import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.router.push(const LoginRoute());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLogo(
              size: screenWidth * 0.5,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              child: const Text('Tap to start ordering'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
