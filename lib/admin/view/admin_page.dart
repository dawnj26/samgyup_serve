import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Admin Page',
        ),
      ),
    );
  }
}
