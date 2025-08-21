import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/edit/inventory_edit_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/edit/inventory_edit_screen.dart';

@RoutePage()
class InventoryEditPage extends StatelessWidget {
  const InventoryEditPage({required this.item, super.key});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryEditBloc(
        inventoryRepository: context.read(),
        item: item,
      ),
      child: const InventoryEditScreen(),
    );
  }
}
