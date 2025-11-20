import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/list/inventory_list_bloc.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/inventory/components/inventory_list_item.dart';

class PackageMenuList extends StatelessWidget {
  const PackageMenuList({required this.menuIds, super.key});

  final List<String> menuIds;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => InventoryListBloc(
        inventoryRepository: context.read(),
        itemIds: menuIds,
      )..add(const InventoryListEvent.started()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'Included Menus',
              style: textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: 8),
          const Expanded(child: _List()),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryListBloc, InventoryListState>(
      builder: (context, state) {
        switch (state.status) {
          case LoadingStatus.loading || LoadingStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case LoadingStatus.success:
            final menus = state.items;
            if (menus.isEmpty) {
              return const Center(child: Text('No menus available'));
            }

            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return InventoryListItem(item: menu);
                },
                itemCount: menus.length,
              ),
            );
          case LoadingStatus.failure:
            return const Center(child: Text('Failed to load menus'));
        }
      },
    );
  }
}
