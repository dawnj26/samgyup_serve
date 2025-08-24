import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/ui/menu/components/components.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final item = MenuItem(
      name: 'Pancit Canton Platter',
      description: 'description',
      price: 200,
      category: 'Noodles',
      ingredients: [],
      createdAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Menu'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: StatusSection(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Menu Items',
                style: textTheme.titleMedium,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 16),
            sliver: SliverList.builder(
              addRepaintBoundaries: false,
              itemBuilder: (_, _) => MenuListItem(
                item: item,
              ),
              itemCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
