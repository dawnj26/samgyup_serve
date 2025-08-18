import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, super.key});

  final InventoryCategory category;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: ListTile(
        title: Text(category.label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO(category): Navigate to category details.
        },
      ),
    );
  }
}
