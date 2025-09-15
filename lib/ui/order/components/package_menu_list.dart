import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/list/menu_list_bloc.dart';
import 'package:samgyup_serve/ui/menu/components/menu_list_item.dart';

class PackageMenuList extends StatelessWidget {
  const PackageMenuList({required this.menuIds, super.key});

  final List<String> menuIds;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => MenuListBloc(
        menuRepository: context.read(),
        menuIds: menuIds,
      )..add(const MenuListEvent.started()),
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
    return BlocBuilder<MenuListBloc, MenuListState>(
      builder: (context, state) {
        switch (state.status) {
          case MenuListStatus.loading || MenuListStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case MenuListStatus.success:
            final menus = state.items;
            if (menus.isEmpty) {
              return const Center(child: Text('No menus available'));
            }

            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return MenuListItem(item: menu);
                },
                itemCount: menus.length,
              ),
            );
          case MenuListStatus.failure:
            return const Center(child: Text('Failed to load menus'));
        }
      },
    );
  }
}
