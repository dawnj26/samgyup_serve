import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/select/menu_select_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuSelectScreen extends StatelessWidget {
  const MenuSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select menu items'),
      ),
      body: const _MenuItems(),
      bottomNavigationBar: const _SelectedBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<MenuSelectBloc>().add(const MenuSelectEvent.saved());
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

class _SelectedBar extends StatelessWidget {
  const _SelectedBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedItemsCount = context.select(
      (MenuSelectBloc bloc) => bloc.state.selectedItems.length,
    );

    if (selectedItemsCount == 0) {
      return const SizedBox.shrink();
    }

    return ColoredBox(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$selectedItemsCount selected'),
            TextButton(
              onPressed: () {
                final items = context
                    .read<MenuSelectBloc>()
                    .state
                    .selectedItems;
                showModalBottomSheet<void>(
                  context: context,
                  builder: (ctx) {
                    return MenuSelectBottomSheet(
                      items: items,
                      onChange: (i) => _handleChange(context, i),
                    );
                  },
                );
              },
              child: const Text('View'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleChange(BuildContext context, List<MenuItem> items) {
    context.read<MenuSelectBloc>().add(
      MenuSelectEvent.selectedItemsChanged(items),
    );
  }
}

class _MenuItems extends StatefulWidget {
  const _MenuItems();

  @override
  State<_MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<_MenuItems> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MenuSelectBloc, MenuSelectState>(
      builder: (context, state) {
        switch (state) {
          case MenuSelectSuccess(
            :final items,
            :final selectedItems,
            :final hasReachedMax,
            :final itemImages,
          ):
            return ListView.builder(
              key: const Key('menuSelectScreen_listView'),
              controller: _controller,
              itemCount: hasReachedMax ? items.length : items.length + 1,
              itemBuilder: (context, i) {
                if (i >= items.length) {
                  return const BottomLoader();
                }

                final item = items[i];
                final file = itemImages[item.id];
                final isSelected = selectedItems.any((e) => e.id == item.id);

                return MenuListItem(
                  key: Key('menuSelectScreen_item_${item.id}'),
                  item: item,
                  color: isSelected ? colorScheme.surfaceContainer : null,
                  image: file == null
                      ? null
                      : Image.file(file, fit: BoxFit.cover),
                  onTap: () {
                    context.read<MenuSelectBloc>().add(
                      MenuSelectEvent.itemToggled(
                        item: item,
                        isSelected: isSelected,
                      ),
                    );
                  },
                );
              },
            );
          case MenuSelectFailure():
            return const Center(child: Text('Failed to load menu items'));
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<MenuSelectBloc>().add(
        const MenuSelectEvent.loadMore(),
      );
    }
  }
}
