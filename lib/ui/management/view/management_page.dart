import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/management/view/management_screen.dart';

@RoutePage()
class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ManagementScreen();
  }
}
