import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/status/inventory_status_bloc.dart';
import 'package:samgyup_serve/ui/inventory/view/list/status/inventory_status_list_screen.dart';

@RoutePage()
class InventoryStatusListPage extends StatelessWidget {
  const InventoryStatusListPage({super.key, this.status});

  final InventoryItemStatus? status;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          InventoryStatusBloc(
            inventoryRepository: context.read<InventoryRepository>(),
            status: status,
          )..add(
            const InventoryStatusEvent.started(),
          ),
      child: const InventoryStatusListScreen(),
    );
  }
}
