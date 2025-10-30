import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
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
                  child: Text(
                    'Categories',
                    style: textTheme.titleMedium,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final category = InventoryCategory.values[index];

                      return CategoryCard(
                        category: category,
                      );
                    },
                    childCount: InventoryCategory.values.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
