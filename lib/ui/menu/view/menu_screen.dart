import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/components/empty_fallback.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
      body: CustomScrollView(
        controller: _scrollController,
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
          SliverToBoxAdapter(
            child: CategoryFilters(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onSelectionChanged: (selected) {
                context.read<MenuBloc>().add(
                  MenuEvent.filterChanged(
                    selectedCategories: selected,
                  ),
                );
              },
            ),
          ),
          const _ItemList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(
            MenuCreateRoute(
              onCreated: () {
                context.read<MenuBloc>().add(const MenuEvent.refresh());
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MenuBloc>().add(
        const MenuEvent.loadMore(),
      );
    }
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

class _ItemList extends StatelessWidget {
  const _ItemList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        switch (state) {
          case MenuLoaded(
            items: final items,
            hasReachedMax: final hasReachedMax,
          ):
            if (items.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyFallback(
                  message: 'No menu items found.',
                  padding: EdgeInsets.all(16),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.only(bottom: 16),
              sliver: SliverList.builder(
                itemBuilder: (ctx, i) {
                  if (i >= items.length) {
                    return const BottomLoader();
                  }
                  final item = items[i];
                  return MenuListItem(
                    item: item,
                    onTap: () {},
                  );
                },
                itemCount: hasReachedMax ? items.length : items.length + 1,
              ),
            );
          case MenuError(:final message):
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(message),
              ),
            );
          default:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
