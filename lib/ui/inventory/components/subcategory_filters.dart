import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:inventory_repository/inventory_repository.dart';

class SubcategoryFilters extends StatefulWidget {
  const SubcategoryFilters({
    required this.subcategories,
    super.key,
    this.onSelectionChanged,
  });

  final List<Subcategory> subcategories;
  final void Function(List<Subcategory>)? onSelectionChanged;

  @override
  State<SubcategoryFilters> createState() => _SubcategoryFiltersState();
}

class _SubcategoryFiltersState extends State<SubcategoryFilters> {
  final List<Subcategory> _selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.subcategories.mapIndexed((i, c) {
          final rightPadding = i == widget.subcategories.length - 1 ? 0.0 : 8.0;

          return Padding(
            padding: EdgeInsets.only(right: rightPadding),
            child: FilterChip(
              label: Text(c.name),
              selected: _selectedItems.contains(c),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedItems.add(c);
                  } else {
                    _selectedItems.remove(c);
                  }
                });
                widget.onSelectionChanged?.call(_selectedItems);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
