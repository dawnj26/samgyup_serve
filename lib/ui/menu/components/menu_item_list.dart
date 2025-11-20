import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/list/inventory_list_bloc.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class MenuItemList extends StatelessWidget {
  const MenuItemList({
    required this.itemBuilder,
    super.key,
  });

  final Widget Function(BuildContext context, InventoryItem item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryListBloc, InventoryListState>(
      builder: (context, state) {
        final items = state.items;
        final hasReachedMax = state.hasReachedMax;

        switch (state.status) {
          case LoadingStatus.success:
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
          case LoadingStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              ),
            );
          case LoadingStatus.loading || LoadingStatus.initial:
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
