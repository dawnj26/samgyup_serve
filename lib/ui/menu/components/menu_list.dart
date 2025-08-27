import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuList extends StatefulWidget {
  const MenuList({required this.items, required this.hasReachedMax, super.key});

  final List<MenuItem> items;
  final bool hasReachedMax;

  @override
  State<MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (ctx, i) {
        if (i >= widget.items.length) {
          return const BottomLoader();
        }
        final item = widget.items[i];
        return MenuListItem(item: item);
      },
      itemCount: widget.hasReachedMax
          ? widget.items.length
          : widget.items.length + 1,
    );
  }
}
