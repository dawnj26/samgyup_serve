import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/food_package/delete/food_package_delete_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/details/food_package_details_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/menu/food_package_menu_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/menu_list_item.dart';

class FoodPackageDetailsScreen extends StatefulWidget {
  const FoodPackageDetailsScreen({super.key});

  @override
  State<FoodPackageDetailsScreen> createState() =>
      _FoodPackageDetailsScreenState();
}

class _FoodPackageDetailsScreenState extends State<FoodPackageDetailsScreen> {
  final _scrollController = ScrollController();
  final _expandedHeight = 300.0;
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _AppBar(
            expandedHeight: _expandedHeight,
            isExpanded: _isExpanded,
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: _Details(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _MenuHeader(),
            ),
          ),
          const _MenuItems(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset < (_expandedHeight + 20 - kToolbarHeight);
  }

  void _handleScroll() {
    if (_isAppBarExpanded != _isExpanded) {
      setState(() {
        _isExpanded = _isAppBarExpanded;
      });
    }
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageDetailsBloc, FoodPackageDetailsState>(
      builder: (context, state) {
        switch (state) {
          case FoodPackageDetailsLoading() || FoodPackageDetailsInitial():
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case FoodPackageDetailsFailure(:final errorMessage):
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Failed to load menu items: $errorMessage'),
              ),
            );
        }

        final menuItems = state.menuItems;

        if (menuItems.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyFallback(
              message: 'No menu items added.\nTap edit to add items.',
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            ),
          );
        }

        return SliverList.builder(
          itemCount: menuItems.length,
          itemBuilder: (ctx, i) {
            final item = menuItems[i];
            return MenuListItem(
              onTap: () => _handleTap(context, item),
              item: item,
            );
          },
        );
      },
    );
  }

  void _handleTap(BuildContext context, MenuItem item) {
    final router = context.router.parent<StackRouter>();
    router?.push(
      MenuDetailsRoute(
        menuItem: item,
        onChange: ({required needsReload}) {
          if (needsReload) {
            context.read<FoodPackageDetailsBloc>().add(
              const FoodPackageDetailsEvent.refreshed(),
            );
          }
        },
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Menu items',
          style: textTheme.labelLarge,
        ),
        BlocBuilder<FoodPackageDetailsBloc, FoodPackageDetailsState>(
          builder: (context, state) {
            final isLoading = state is FoodPackageDetailsLoading;

            return TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context.router.push(
                        MenuSelectRoute(
                          initialItems: state.menuItems,
                          onSave: (items) => _handleChange(context, items),
                        ),
                      );
                    },
              child: const Text('Edit'),
            );
          },
        ),
      ],
    );
  }

  void _handleChange(BuildContext context, List<MenuItem> items) {
    final ids = items.map((e) => e.id).toList();
    context.read<FoodPackageMenuBloc>().add(
      FoodPackageMenuEvent.started(menuIds: ids),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Builder(
          builder: (ctx) {
            final name = ctx.select(
              (FoodPackageDetailsBloc bloc) => bloc.state.package.name,
            );
            return Text(
              name,
              style: textTheme.headlineMedium,
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Builder(
              builder: (ctx) {
                final price = ctx.select(
                  (FoodPackageDetailsBloc bloc) => bloc.state.package.price,
                );

                return Text(
                  CurrencyFormatter.formatToPHP(price),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(
                  Icons.timelapse_rounded,
                  size: 20,
                  color: Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Builder(
                  builder: (ctx) {
                    final duration = ctx.select(
                      (FoodPackageDetailsBloc bloc) =>
                          bloc.state.package.timeLimit,
                    );

                    return Text(
                      '$duration minutes',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.red.shade700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        InfoCard(
          title: 'Description',
          child: Builder(
            builder: (ctx) {
              final description = ctx.select(
                (FoodPackageDetailsBloc bloc) => bloc.state.package.description,
              );

              return Text(
                description,
                style: textTheme.bodyMedium,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.expandedHeight, required this.isExpanded});

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
      pinned: true,
      expandedHeight: expandedHeight,
      title: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isExpanded ? 0 : 1,
        child: Builder(
          builder: (ctx) {
            final name = ctx.select(
              (FoodPackageDetailsBloc bloc) => bloc.state.package.name,
            );
            return Text(name);
          },
        ),
      ),
      leading: IconButton(
        onPressed: () {
          context.router.pop();
        },
        icon: const Icon(Icons.arrow_back),
        style: buttonStyle,
      ),
      actions: [
        PackageMoreOptionButton(
          style: buttonStyle,
          onSelected: (option) => _handleSelected(context, option),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Builder(
          builder: (ctx) {
            final image = ctx.select(
              (FoodPackageDetailsBloc bloc) => bloc.state.package.imageFilename,
            );

            return image != null
                ? PackageImage(filename: image)
                : const NoImageFallback();
          },
        ),
      ),
    );
  }

  Future<void> _handleSelected(
    BuildContext context,
    PackageMoreOption option,
  ) async {
    final package = context.read<FoodPackageDetailsBloc>().state.package;

    switch (option) {
      case PackageMoreOption.delete:
        final delete = await showDeleteDialog(
          context: context,
          title: 'Delete package',
          message: 'Are you sure you want to delete this package?',
        );

        if (!context.mounted || !delete) return;

        context.read<FoodPackageDeleteBloc>().add(
          FoodPackageDeleteEvent.started(
            packageId: package.id,
          ),
        );
      case PackageMoreOption.edit:
        await context.router.push(
          FoodPackageEditRoute(
            package: package,
            onChanged: (package) {
              context.read<FoodPackageDetailsBloc>().add(
                FoodPackageDetailsEvent.changed(package),
              );
            },
          ),
        );
    }
  }
}
