import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/bottom_sheet_layout.dart';

class MenuSelectBottomSheet extends StatefulWidget {
  const MenuSelectBottomSheet({required this.items, super.key, this.onChange});

  final List<MenuItem> items;
  final void Function(List<MenuItem> items)? onChange;

  @override
  State<MenuSelectBottomSheet> createState() => _MenuSelectBottomSheetState();
}

class _MenuSelectBottomSheetState extends State<MenuSelectBottomSheet> {
  late List<MenuItem> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.75;
    final textTheme = Theme.of(context).textTheme;

    return BottomSheetLayout(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Select Menu Items',
              style: textTheme.labelLarge,
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (ctx, i) {
                final item = _items[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(formatToPHP(item.price)),
                  trailing: IconButton(
                    onPressed: () {
                      final updatedItems = _items
                          .where((e) => e.id != item.id)
                          .toList();
                      setState(() {
                        _items = updatedItems;
                      });
                      widget.onChange?.call(updatedItems);
                    },
                    icon: const Icon(Icons.close),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
