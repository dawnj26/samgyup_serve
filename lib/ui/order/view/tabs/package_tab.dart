import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/food_package/tab/food_package_tab_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/components/bottom_loader.dart';
import 'package:samgyup_serve/ui/components/layouts/infinite_scroll_layout.dart';
import 'package:samgyup_serve/ui/food_package/components/components.dart';
import 'package:samgyup_serve/ui/order/components/package_menu_list.dart';

class PackageTab extends StatelessWidget {
  const PackageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodPackageTabBloc(
        packageRepository: context.read<PackageRepository>(),
      )..add(const FoodPackageTabEvent.started()),
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
    return InfiniteScrollLayout(
      onLoadMore: () {
        context.read<FoodPackageTabBloc>().add(
          const FoodPackageTabEvent.fetchMore(),
        );
      },
      slivers: const [
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: _PackageList(),
        ),
        SliverToBoxAdapter(
          child: _BottomLoader(),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PackageList extends StatelessWidget {
  const _PackageList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodPackageTabBloc, FoodPackageTabState>(
      builder: (context, state) {
        switch (state.status) {
          case FoodPackageTabStatus.initial || FoodPackageTabStatus.loading:
            return const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case FoodPackageTabStatus.success:
            final packages = state.items;

            if (packages.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text('No packages available.'),
                ),
              );
            }

            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 1,
              ),
              itemCount: packages.length,
              itemBuilder: (ctx, i) {
                final package = packages[i];

                return _Item(package: package);
              },
            );
          case FoodPackageTabStatus.failure:
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Error: ${state.errorMessage}'),
              ),
            );
        }
      },
    );
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    final hasReachedMax = context.select(
      (FoodPackageTabBloc bloc) => bloc.state.hasReachedMax,
    );

    if (hasReachedMax) {
      return const SizedBox.shrink();
    }
    return const BottomLoader();
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.package});

  final FoodPackage package;

  @override
  Widget build(BuildContext context) {
    final cartItems = context.select(
      (OrderCartBloc bloc) => bloc.state.packages,
    );
    final cartIndex = cartItems.indexWhere((e) => e.item.id == package.id);

    if (cartIndex == -1) {
      return PackageTile(
        onTap: () => _handlePackageTap(context, package),
        package: package,
      );
    }

    final cart = cartItems[cartIndex];

    return Badge.count(
      count: cart.quantity,
      alignment: Alignment.bottomRight,
      offset: const Offset(-16, -12),
      child: PackageTile(
        onTap: () => _handlePackageTap(context, package, cart.quantity),
        package: package,
      ),
    );
  }

  Future<void> _handlePackageTap(
    BuildContext context,
    FoodPackage package, [
    int? initialValue,
  ]) async {
    final tableSize = context.read<AppBloc>().state.deviceData!.table!.capacity;
    final timeLimit = package.timeLimit / 60;

    final quantity = await showAddCartItemDialog(
      initialValue: initialValue,
      context: context,
      name: '${package.name} (${timeLimit.toStringAsFixed(1)} hr)',
      description: package.description,
      price: package.price,
      maxQuantity: tableSize,
      imageId: package.imageFilename,
      content: PackageMenuList(menuIds: package.menuIds),
      onTap: () => context.read<ActivityBloc>().add(
        const ActivityEvent.started(),
      ),
    );

    if (!context.mounted || quantity == null) return;

    context.read<OrderCartBloc>().add(
      OrderCartEvent.addPackage(
        CartItem(
          item: package,
          quantity: quantity,
        ),
      ),
    );
  }
}
