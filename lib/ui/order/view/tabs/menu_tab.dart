import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/menu/tab/menu_tab_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/menu/components/menu_list_item.dart';

class MenuTab extends StatelessWidget {
  const MenuTab({required this.category, super.key});

  final MenuCategory category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuTabBloc(
        menuRepository: context.read<MenuRepository>(),
        category: category,
      )..add(const MenuTabEvent.started()),
      child: const _Tab(),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab();

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<MenuTabBloc>()
          ..add(const MenuTabEvent.refresh());

        await bloc.stream.firstWhere(
          (state) => state.status != MenuTabStatus.refreshing,
        );
      },
      child: InfiniteScrollLayout(
        onLoadMore: () {
          context.read<MenuTabBloc>().add(const MenuTabEvent.fetchMore());
        },
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: const [
          _MenuList(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuTabBloc, MenuTabState>(
      builder: (context, state) {
        switch (state.status) {
          case MenuTabStatus.initial || MenuTabStatus.loading:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            );
          case MenuTabStatus.success || MenuTabStatus.refreshing:
            final items = state.items;
            final hasReachedMax = state.hasReachedMax;

            if (items.isEmpty) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No items')),
              );
            }

            return SliverList.builder(
              itemCount: hasReachedMax ? items.length : items.length + 1,
              itemBuilder: (context, index) {
                if (index >= items.length) {
                  return const BottomLoader();
                }

                final item = items[index];
                return _Item(item: item);
              },
            );
          case MenuTabStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(state.errorMessage ?? 'Error')),
            );
        }
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.item});

  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select(
      (OrderCartBloc bloc) => bloc.state.menuItems,
    );
    final cartIndex = cartItems.indexWhere((e) => e.item.id == item.id);

    if (cartIndex == -1) {
      return MenuListItem(
        item: item,
        onTap: item.isAvailable ? () => _handleItemTap(context, item) : null,
      );
    }

    final cart = cartItems[cartIndex];
    return Badge.count(
      alignment: Alignment.bottomRight,

      offset: const Offset(-12, -26),
      count: cart.quantity,
      child: MenuListItem(
        item: item,
        onTap: item.isAvailable
            ? () => _handleItemTap(context, item, cart.quantity)
            : null,
      ),
    );
  }

  Future<void> _handleItemTap(
    BuildContext context,
    MenuItem item, [
    int? initialValue,
  ]) async {
    final quantity = await showAddCartItemDialog(
      context: context,
      name: item.name,
      description: item.description,
      price: item.price,
      maxQuantity: item.stock,
      imageId: item.imageFileName,
      initialValue: initialValue,
      onTap: () => context.read<ActivityBloc>().add(
        const ActivityEvent.started(),
      ),
    );

    if (!context.mounted || quantity == null) return;

    context.read<OrderCartBloc>().add(
      OrderCartEvent.addMenuItem(
        CartItem(
          item: item,
          quantity: quantity,
        ),
      ),
    );
  }
}
