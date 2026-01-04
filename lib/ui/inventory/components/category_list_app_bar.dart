import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/category/delete/category_delete_bloc.dart';
import 'package:samgyup_serve/bloc/category/form/category_form_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/category/inventory_category_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';

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
          pinned: true,
          expandedHeight: 200,
          backgroundColor: colorScheme.primaryContainer,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(category),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                unawaited(
                  context.router.push(
                    SubcategoriesRoute(
                      category: category,
                      onPop: () {
                        context.read<InventoryCategoryBloc>().add(
                          const InventoryCategoryEvent.reload(),
                        );
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.category_outlined),
              label: const Text('Categories'),
            ),
            if (state.categoryId != null) ...[
              IconButton(
                onPressed: () async {
                  final confirm = await showConfirmationDialog(
                    context: context,
                    title: 'Delete Category',
                    message:
                        'Are you sure you want to delete this category? '
                        'all items under this category will be moved to '
                        '"Others".',
                  );

                  if (!context.mounted || !confirm) return;

                  final items = context
                      .read<InventoryCategoryBloc>()
                      .state
                      .items;

                  context.read<CategoryDeleteBloc>().add(
                    CategoryDeleteEvent.started(
                      categoryId: state.categoryId!,
                      items: items,
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline),
              ),
              IconButton(
                onPressed: () async {
                  final initialName = state.category;
                  final name = await showTextInputDialog(
                    context: context,
                    title: 'Edit category',
                    initialValue: category,
                    validator: (value) {
                      final cleanedValue = value.trim();

                      if (cleanedValue.isEmpty) {
                        return 'Category name cannot be empty';
                      }
                      if (cleanedValue.length < 3) {
                        return 'Category name must be at least 3 '
                            'characters long';
                      }

                      return null;
                    },
                  );

                  if (!context.mounted || name == null || name == initialName) {
                    return;
                  }

                  context.read<CategoryFormBloc>().add(
                    CategoryFormEvent.updated(
                      id: state.categoryId!,
                      name: name,
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ],
        );
      },
    );
  }
}
