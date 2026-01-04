import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, super.key, this.onTap});

  final String category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: ListTile(
        title: Text(category),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
