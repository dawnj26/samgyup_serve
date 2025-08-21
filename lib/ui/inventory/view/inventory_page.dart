import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/inventory_screen.dart';

@RoutePage()
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InventoryBloc(inventoryRepository: context.read())
            ..add(const InventoryEvent.started()),
      child: const InventoryScreen(),
    );
  }
}
