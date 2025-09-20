import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/ingredient/select/ingredient_select_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/item_tile.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class IngredientSelectScreen extends StatelessWidget {
  const IngredientSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Ingredients')),
      body: const Column(
        children: [
          Expanded(child: _ItemList()),
          _SelectedBar(),
        ],
      ),
      floatingActionButton: const _FloatingAction(),
    );
  }
}

class _FloatingAction extends StatelessWidget {
  const _FloatingAction();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientSelectBloc, IngredientSelectState>(
      buildWhen: (p, c) =>
          p.selectedIngredients.length != c.selectedIngredients.length,
      builder: (context, state) {
        final bottomPadding = state.selectedIngredients.isEmpty ? 0.0 : 64.0;

        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: FloatingActionButton(
            onPressed: () => context.router.pop(
              context.read<IngredientSelectBloc>().state.selectedIngredients,
            ),
            child: const Icon(Icons.check),
          ),
        );
      },
    );
  }
}

class _SelectedBar extends StatelessWidget {
  const _SelectedBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IngredientSelectBloc, IngredientSelectState>(
      buildWhen: (p, c) =>
          p.selectedIngredients.length != c.selectedIngredients.length,
      builder: (context, state) {
        if (state.selectedIngredients.isEmpty) {
          return const SizedBox.shrink();
        }

        final count = state.selectedIngredients.length;

        return SelectedIngredientsBar(
          count: count,
          onView: () => _handleView(context, state.selectedIngredients),
        );
      },
    );
  }

  Future<void> _handleView(
    BuildContext context,
    List<Ingredient> ingredients,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SelectedIngredientsBottomSheet(
        ingredients: ingredients,
        onRemove: (ingredient) {
          context.read<IngredientSelectBloc>().add(
            IngredientSelectEvent.ingredientRemoved(
              ingredient.inventoryItemId,
            ),
          );
        },
      ),
    );
  }
}

class _ItemList extends StatefulWidget {
  const _ItemList();

  @override
  State<_ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<_ItemList> {
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
    return BlocBuilder<IngredientSelectBloc, IngredientSelectState>(
      builder: (context, state) {
        switch (state) {
          case IngredientSelectLoaded(
            items: final items,
            hasReachedMax: final hasReachedMax,
            selectedIngredients: final selectedIngredients,
          ):
            return ListView.builder(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              itemBuilder: (ctx, i) {
                if (i >= items.length) {
                  return const BottomLoader();
                }
                final item = items[i];
                final isItemSelected = selectedIngredients.any(
                  (ingredient) => ingredient.inventoryItemId == item.id,
                );

                return ItemTile(
                  item: item,
                  onTap: () => _handleItemTap(item, isItemSelected),
                  trailing: Checkbox(
                    value: isItemSelected,
                    onChanged: (checked) =>
                        _handleItemTap(item, isItemSelected),
                  ),
                );
              },
              itemCount: hasReachedMax ? items.length : items.length + 1,
            );
          case IngredientSelectFailure(:final errorMessage):
            return Center(
              child: Text('Failed to load ingredients: $errorMessage'),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
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
      context.read<IngredientSelectBloc>().add(
        const IngredientSelectEvent.loadMore(),
      );
    }
  }

  Future<void> _handleItemTap(InventoryItem item, bool isSelected) async {
    if (isSelected) {
      return context.read<IngredientSelectBloc>().add(
        IngredientSelectEvent.ingredientRemoved(item.id),
      );
    }

    final ingredient = await showDialog<Ingredient>(
      context: context,
      builder: (ctx) => IngredientSelectDialog(item: item),
    );

    if (!mounted || ingredient == null) return;

    context.read<IngredientSelectBloc>().add(
      IngredientSelectEvent.ingredientSelected(ingredient),
    );
  }
}
