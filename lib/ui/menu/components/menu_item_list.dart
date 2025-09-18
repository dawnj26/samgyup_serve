import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuItemList extends StatelessWidget {
  const MenuItemList({
    required this.itemBuilder,
    super.key,
  });

  final Widget Function(BuildContext context, MenuItem menu) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        switch (state) {
          case MenuLoaded(
            items: final items,
            hasReachedMax: final hasReachedMax,
          ):
            if (items.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyFallback(
                  message: 'No menu items found.',
                  padding: EdgeInsets.all(16),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.only(bottom: 16),
              sliver: SliverList.builder(
                itemBuilder: (ctx, i) {
                  if (i >= items.length) {
                    return const BottomLoader();
                  }
                  final item = items[i];
                  return Builder(builder: (ctx) => itemBuilder(ctx, item));
                },
                itemCount: hasReachedMax ? items.length : items.length + 1,
              ),
            );
          case MenuError(:final message):
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(message),
              ),
            );
          default:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }
}
