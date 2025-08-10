import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/app/router/router.dart';
import 'package:samgyup_serve/components/components.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: AppLogo(
                  size: screenWidth * 0.6,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                child: const Text('Start Ordering'),
                onPressed: () {},
              ),
              TextButton(
                onPressed: () {
                  context.router.push(const LoginRoute());
                },
                child: const Text('Login as admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
