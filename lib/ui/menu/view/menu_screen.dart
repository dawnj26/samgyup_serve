import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Menu'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: InfiniteScrollLayout(
        onLoadMore: () => context.read<MenuBloc>().add(
          const MenuEvent.loadMore(),
        ),
        slivers: [
          const _Status(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
              child: Text(
                'Menu Items',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: MenuFilter(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          MenuItemList(
            itemBuilder: (context, menu) => MenuListItem(
              item: menu,
              onTap: () => _handleTap(context, menu),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handlePressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleTap(BuildContext context, MenuItem menu) {
    unawaited(
      context.router.push(
        MenuDetailsRoute(
          menuItem: menu,
          onChange: ({required needsReload}) {
            if (needsReload) {
              context.read<MenuBloc>().add(
                const MenuEvent.refresh(),
              );
            }
          },
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context) {
    unawaited(
      context.router.push(
        MenuCreateRoute(
          onCreated: () {
            context.read<MenuBloc>().add(const MenuEvent.refresh());
          },
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<MenuBloc, MenuState>(
        buildWhen: (p, c) => p.menuInfo != c.menuInfo,
        builder: (context, state) {
          final isLoading = state is MenuLoading || state is MenuInitial;

          return StatusSection(
            menuInfo: state.menuInfo,
            isLoading: isLoading,
          );
        },
      ),
    );
  }
}
