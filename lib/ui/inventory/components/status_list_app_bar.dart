import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/status/inventory_status_bloc.dart';
import 'package:samgyup_serve/data/enums/status_color.dart';

class StatusListAppBar extends StatelessWidget {
  const StatusListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryStatusBloc, InventoryStatusState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        var title = 'All Items';
        final status = state.status;

        if (status != null) {
          final statusName = state.status!.label;
          title = '$statusName Items';
        }

        return SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final triggerReload =
                  context.read<InventoryDeleteBloc>().state
                      is InventoryDeleteSuccess;
              context.router.pop(triggerReload);
            },
          ),
          pinned: true,
          expandedHeight: 200,
          backgroundColor: status == null
              ? Colors.blue.shade200
              : status.color.shade200,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(title),
          ),
          actions: const [SizedBox.shrink()],
        );
      },
    );
  }
}
