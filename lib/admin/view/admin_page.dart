import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/admin/view/admin_screen.dart';

@RoutePage()
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScreen();
  }
}
