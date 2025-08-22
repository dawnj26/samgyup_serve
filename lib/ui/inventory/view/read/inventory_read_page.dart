import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/ui/inventory/view/read/inventory_read_screen.dart';

@RoutePage()
class InventoryReadPage extends StatelessWidget {
  const InventoryReadPage({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return const InventoryReadScreen();
  }
}
