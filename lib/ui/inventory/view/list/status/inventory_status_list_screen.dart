import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/status/inventory_status_bloc.dart';
import 'package:samgyup_serve/ui/inventory/components/inventory_item_list.dart';

class InventoryStatusListScreen extends StatelessWidget {
  const InventoryStatusListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<InventoryStatusBloc, InventoryStatusState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            var title = 'All Items';

            if (state.status != null) {
              final statusName = state.status!.label;
              title = '$statusName Items';
            }

            return Text(title);
          },
        ),
      ),
      body: const InventoryItemList(),
    );
  }
}
