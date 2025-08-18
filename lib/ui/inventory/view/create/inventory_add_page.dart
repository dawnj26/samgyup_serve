import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/create/inventory_create_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/create/inventory_add_screen.dart';

@RoutePage()
class InventoryAddPage extends StatelessWidget {
  const InventoryAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryCreateBloc(
        inventoryRepository: context.read(),
      ),
      child: const InventoryAddScreen(),
    );
  }
}
