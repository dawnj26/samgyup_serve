import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';

class CategoryFilters extends StatefulWidget {
  const CategoryFilters({super.key, this.onSelectionChanged, this.padding});

  final void Function(List<MenuCategory>)? onSelectionChanged;
  final EdgeInsetsGeometry? padding;

  @override
  State<CategoryFilters> createState() => _CategoryFiltersState();
}

class _CategoryFiltersState extends State<CategoryFilters> {
  List<MenuCategory> selectedCategories = [];

  void _toggleCategory(MenuCategory category, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedCategories = [...selectedCategories, category];
      } else {
        selectedCategories = selectedCategories
            .where((c) => c != category)
            .toList(growable: false);
      }
    });

    widget.onSelectionChanged?.call(selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: widget.padding,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: MenuCategory.values.mapIndexed((i, cat) {
          final rightPadding = i != MenuCategory.values.length - 1 ? 8.0 : 0.0;
          final isSelected = selectedCategories.contains(cat);

          return Padding(
            key: ValueKey('category_filter_$i'),
            padding: EdgeInsets.only(right: rightPadding),
            child: FilterChip(
              selected: isSelected,
              label: Text(cat.label),
              onSelected: (s) {
                _toggleCategory(cat, s);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
