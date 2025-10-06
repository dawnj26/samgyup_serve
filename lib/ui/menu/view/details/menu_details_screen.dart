import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/ingredient/edit/ingredient_edit_bloc.dart';
import 'package:samgyup_serve/bloc/menu/delete/menu_delete_bloc.dart';
import 'package:samgyup_serve/bloc/menu/details/menu_details_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuDetailsScreen extends StatefulWidget {
  const MenuDetailsScreen({super.key});

  @override
  State<MenuDetailsScreen> createState() => _MenuDetailsScreenState();
}

class _MenuDetailsScreenState extends State<MenuDetailsScreen> {
  final _scrollController = ScrollController();
  final double _expandedHeight = 400;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_isAppBarExpanded != _isExpanded) {
        setState(() {
          _isExpanded = _isAppBarExpanded;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _MenuAppbar(
            expandedHeight: _expandedHeight,
            isExpanded: _isExpanded,
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: InfoCard(title: 'Description', child: _MenuDescription()),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _Stock(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _IngredientHeader(),
            ),
          ),
          const _IngredientList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset < (_expandedHeight - kToolbarHeight);
  }
}

class _Stock extends StatelessWidget {
  const _Stock();

  @override
  Widget build(BuildContext context) {
    final stock = context.select(
      (MenuDetailsBloc bloc) => bloc.state.menuItem.stock,
    );
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Available stock: $stock',
                style: textTheme.labelLarge,
              ),
              Builder(
                builder: (context) {
                  final isLoading = context.select(
                    (MenuDetailsBloc bloc) =>
                        bloc.state is MenuDetailsLoading ||
                        bloc.state is MenuDetailsUpdating ||
                        bloc.state is MenuDetailsInitial,
                  );

                  return IconButton(
                    onPressed: () =>
                        isLoading ? null : _handleEditStock(context, stock),
                    icon: const Icon(Icons.edit_outlined),
                    iconSize: 20,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleEditStock(BuildContext context, int currentStock) async {
    final ingredientItems = context.read<MenuDetailsBloc>().state.ingredients;
    final inventoryItems = context.read<MenuDetailsBloc>().state.inventoryItems;

    var maxStock = double.infinity;

    for (final ingredient in ingredientItems) {
      final inventoryItem = inventoryItems[ingredient.inventoryItemId];
      if (inventoryItem == null || ingredient.quantity <= 0) continue;

      final possibleStock = (inventoryItem.stock / ingredient.quantity).floor();
      if (possibleStock < maxStock) {
        maxStock = possibleStock.toDouble();
      }
    }

    final minServings = maxStock.isFinite ? maxStock.toInt() : 0;

    final newStock = await showQuantityDialog(
      context: context,
      initialValue: currentStock,
      maxValue: minServings + currentStock,
      title: 'Set Stock',
    );

    log('Max servings: $minServings, New stock: $newStock', name: '_Stock');

    if (!context.mounted || newStock == null || newStock == currentStock) {
      return;
    }

    context.read<MenuDetailsBloc>().add(
      MenuDetailsEvent.stockUpdated(newStock),
    );
  }
}

class _IngredientHeader extends StatelessWidget {
  const _IngredientHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Ingredients',
          style: textTheme.titleMedium,
        ),
        TextButton(
          onPressed: () async {
            final ingredients = context
                .read<MenuDetailsBloc>()
                .state
                .ingredients;
            final updatedIngredients = await context.router
                .push<List<Ingredient>>(
                  IngredientSelectRoute(initialValue: ingredients),
                );

            if (!context.mounted || updatedIngredients == null) return;

            context.read<IngredientEditBloc>().add(
              IngredientEditEvent.submitted(
                ingredients: updatedIngredients,
                menuId: context.read<MenuDetailsBloc>().state.menuItem.id,
              ),
            );
          },
          child: const Text('Edit'),
        ),
      ],
    );
  }
}

class _IngredientList extends StatelessWidget {
  const _IngredientList();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      builder: (context, state) {
        switch (state) {
          case MenuDetailsLoading() || MenuDetailsInitial():
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case MenuDetailsError(:final message):
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Error: $message',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            );
          default:
            final ingredients = state.ingredients;

            if (ingredients.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyFallback(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  message: '''
No ingredients added.
Tap the Edit button to add some.
''',
                ),
              );
            }

            return SliverList.builder(
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                final inventoryItem =
                    state.inventoryItems[ingredient.inventoryItemId];

                return IngredientTile(
                  ingredient: ingredient,
                  inventoryItem: inventoryItem,
                );
              },
              itemCount: ingredients.length,
            );
        }
      },
    );
  }
}

class _MenuDescription extends StatelessWidget {
  const _MenuDescription();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      buildWhen: (p, c) => p.menuItem.description != c.menuItem.description,
      builder: (context, state) {
        final description = state.menuItem.description;
        return Text(
          description,
          style: textTheme.bodyMedium,
        );
      },
    );
  }
}

class _MenuAppbar extends StatelessWidget {
  const _MenuAppbar({required this.expandedHeight, required this.isExpanded});

  final double expandedHeight;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonStyle = isExpanded
        ? IconButton.styleFrom(
            backgroundColor: colorScheme.surface,
          )
        : null;

    return SliverAppBar(
      leading: AutoLeadingButton(
        builder: (context, leadingType, action) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              style: buttonStyle,
              onPressed: action,
              icon: const Icon(Icons.arrow_back),
            ),
          );
        },
      ),
      actionsPadding: const EdgeInsets.only(right: 8),
      actions: [
        MenuOptionsButton(
          style: buttonStyle,
          onSelected: (option) => _handleSelected(context, option),
        ),
      ],
      pinned: true,
      expandedHeight: expandedHeight,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: !isExpanded ? 1.0 : 0.0,
        child: BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
          builder: (context, state) {
            final name = state.menuItem.name;
            return Text(name);
          },
        ),
      ),
      flexibleSpace: const FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _MenuImage(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MenuTitle(),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _MenuCategory(),
                          SizedBox(width: 8),
                          _MenuStatus(),
                        ],
                      ),
                      SizedBox(width: 16),
                      _MenuPrice(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirm =
        (await showDialog<bool>(
          context: context,
          builder: (context) => const MenuDeleteDialog(),
        )) ??
        false;

    if (!context.mounted || !confirm) return;

    final item = context.read<MenuDetailsBloc>().state.menuItem;
    context.read<MenuDeleteBloc>().add(
      MenuDeleteEvent.started(menuId: item.id),
    );
  }

  Future<void> _handleSelected(BuildContext context, MenuOptions option) async {
    switch (option) {
      case MenuOptions.edit:
        final item = context.read<MenuDetailsBloc>().state.menuItem;
        await context.router.push(
          MenuEditRoute(
            menuItem: item,
            onChange: ({required needsReload}) {
              if (needsReload) {
                context.read<MenuDetailsBloc>().add(
                  const MenuDetailsEvent.menuReloaded(),
                );
              }
            },
          ),
        );
      case MenuOptions.delete:
        await _handleDelete(context);
    }
  }
}

class _MenuPrice extends StatelessWidget {
  const _MenuPrice();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      builder: (context, state) {
        return Text(
          formatToPHP(
            state.menuItem.price,
          ),
          style: textTheme.titleMedium,
        );
      },
    );
  }
}

class _MenuCategory extends StatelessWidget {
  const _MenuCategory();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final category = context.select(
      (MenuDetailsBloc bloc) => bloc.state.menuItem.category,
    );

    return Text(
      category.label,
      style: textTheme.titleMedium,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MenuStatus extends StatelessWidget {
  const _MenuStatus();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      builder: (context, state) {
        return AvailableBadge(isAvailable: state.menuItem.isAvailable);
      },
    );
  }
}

class _MenuTitle extends StatelessWidget {
  const _MenuTitle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      buildWhen: (p, c) => p.menuItem.name != c.menuItem.name,
      builder: (context, state) {
        final textTheme = Theme.of(context).textTheme;

        return Text(
          state.menuItem.name,
          style: textTheme.headlineMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}

class _MenuImage extends StatelessWidget {
  const _MenuImage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<MenuDetailsBloc, MenuDetailsState>(
      buildWhen: (p, c) => p.menuItem.imageFileName != c.menuItem.imageFileName,
      builder: (context, state) {
        final imageFileName = state.menuItem.imageFileName;

        if (imageFileName == null) {
          return ColoredBox(
            color: colorScheme.surfaceContainerLow,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'No Image Available',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }

        return MenuImage(fileId: imageFileName);
      },
    );
  }
}
