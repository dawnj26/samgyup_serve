import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/inventory_bloc.dart';
import 'package:samgyup_serve/router/router.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, super.key});

  final InventoryCategory category;

  Future<void> _handleNavigation(
    BuildContext context,
    InventoryCategory category,
  ) async {
    final triggerReload =
        (await context.router.push<bool>(
          InventoryCategoryListRoute(category: category),
        )) ??
        false;
    if (!context.mounted || !triggerReload) return;

    context.read<InventoryBloc>().add(
      const InventoryEvent.reload(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: ListTile(
        title: Text(category.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _handleNavigation(context, category),
      ),
    );
  }
}
