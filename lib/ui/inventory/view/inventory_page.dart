import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/inventory/view/inventory_screen.dart';

@RoutePage()
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InventoryScreen();
  }
}
