import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuFilter extends StatelessWidget {
  const MenuFilter({
    super.key,
    this.padding,
  });

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return CategoryFilters(
      padding: padding,
      onSelectionChanged: (selected) {
        context.read<MenuBloc>().add(
          MenuEvent.filterChanged(
            selectedCategories: selected,
          ),
        );
      },
    );
  }
}
