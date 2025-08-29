import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class FoodPackageScreen extends StatelessWidget {
  const FoodPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Package Screen'),
      ),
      body: const Center(
        child: Text('This is the Package Screen'),
      ),
    );
  }
}
