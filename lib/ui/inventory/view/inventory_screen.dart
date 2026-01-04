import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/category/category_bloc.dart';
import 'package:samgyup_serve/bloc/category/form/category_form_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Inventory'),
        backgroundColor: colorTheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              context.read<InventoryBloc>().add(const InventoryEvent.sync());
            },
            icon: const Icon(Icons.sync),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final bloc = context.read<InventoryBloc>()
              ..add(const InventoryEvent.reload());

            await bloc.stream.firstWhere(
              (state) => state is! InventoryReloading,
            );
          },
          child: CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                sliver: SliverToBoxAdapter(
                  child: StatusSection(),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Categories',
                        style: textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _handleAddCategory(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
                sliver: _Categories(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Item'),
        onPressed: () async {
          final isItemCreated =
              (await context.router.push<bool>(
                const InventoryAddRoute(),
              )) ??
              false;

          if (!context.mounted) return;

          if (isItemCreated) {
            context.read<InventoryBloc>().add(const InventoryEvent.reload());
          }
        },
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleAddCategory(BuildContext context) async {
    final name = await showTextInputDialog(
      context: context,
      title: 'Add category',
      validator: (value) {
        final cleanedValue = value.trim();

        if (cleanedValue.isEmpty) {
          return 'Category name cannot be empty';
        }
        if (cleanedValue.length < 3) {
          return 'Category name must be at least 3 characters long';
        }

        return null;
      },
    );

    if (name == null || !context.mounted) return;

    context.read<CategoryFormBloc>().add(
      CategoryFormEvent.created(name: name),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CategoryBloc>().state;
    final status = state.status;

    if (status == LoadingStatus.loading || status == LoadingStatus.initial) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (status == LoadingStatus.failure) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            state.errorMessage ?? 'Failed to load categories',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final categoryNames = [
      ...InventoryCategory.values.map(
        (e) => e.name,
      ),
      ...state.categories.map((e) => e.name),
    ];
    final categoryLabels = [
      ...InventoryCategory.values.map(
        (e) => e.label,
      ),
      ...state.categories.map((e) => e.name),
    ];

    final categoryIds = [
      ...List.generate(
        InventoryCategory.values.length,
        (index) => null,
      ),
      ...state.categories.map((e) => e.id),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final label = categoryLabels[index];
          final name = categoryNames[index];

          return CategoryCard(
            category: label,
            onTap: () => _handleNavigation(context, name, categoryIds[index]),
          );
        },
        childCount: categoryLabels.length,
      ),
    );
  }

  Future<void> _handleNavigation(
    BuildContext context,
    String category,
    String? categoryId,
  ) async {
    final triggerReload =
        (await context.router.push<bool>(
          InventoryCategoryListRoute(
            category: category,
            categoryId: categoryId,
          ),
        )) ??
        false;
    if (!context.mounted || !triggerReload) return;

    context.read<InventoryBloc>().add(
      const InventoryEvent.reload(),
    );
    context.read<CategoryBloc>().add(
      const CategoryEvent.started(),
    );
  }
}
