import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/category/inventory_category_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';

class CategoryListAppBar extends StatelessWidget {
  const CategoryListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryCategoryBloc, InventoryCategoryState>(
      buildWhen: (previous, current) => previous.category != current.category,
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        final category = state.category;

        return SliverAppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final triggerReload =
                  context.read<InventoryDeleteBloc>().state
                      is InventoryDeleteSuccess;
              context.router.pop(triggerReload);
            },
          ),
          pinned: true,
          expandedHeight: 200,
          backgroundColor: colorScheme.primaryContainer,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(category.label),
          ),
          actions: const [SizedBox.shrink()],
        );
      },
    );
  }
}
