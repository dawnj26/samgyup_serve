import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/category/inventory_category_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventoryCategoryListScreen extends StatefulWidget {
  const InventoryCategoryListScreen({super.key});

  @override
  State<InventoryCategoryListScreen> createState() =>
      _InventoryCategoryListScreenState();
}

class _InventoryCategoryListScreenState
    extends State<InventoryCategoryListScreen> {
  final _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  InventoryItem _selectedItem = InventoryItem.empty();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryDeleteBloc, InventoryDeleteState>(
      listener: _handleListener,
      child: Scaffold(
        key: scaffoldKey,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CategoryListAppBar(),
            BlocBuilder<InventoryCategoryBloc, InventoryCategoryState>(
              builder: (context, state) {
                switch (state) {
                  case InventoryCategoryLoaded(:final items):
                    return InventoryItemList(
                      key: const Key('inventory_category_list'),
                      items: items,
                      hasReachedMax: state.hasReachedMax,
                      onEdit: _handleEdit,
                      onTap: _handleTap,
                    );
                  case InventoryCategoryError(:final message):
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(message),
                      ),
                    );
                  default:
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                }
              },
            ),
          ],
        ),
        endDrawer: DetailDrawer(
          item: _selectedItem,
        ),
        endDrawerEnableOpenDragGesture: false,
      ),
    );
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<InventoryCategoryBloc>().add(
        const InventoryCategoryEvent.loadMore(),
      );
    }
  }

  void _handleListener(BuildContext context, InventoryDeleteState state) {
    switch (state) {
      case InventoryDeleteLoading():
        unawaited(
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            useRootNavigator: false,
            builder: (ctx) {
              return const LoadingDialog(
                message: 'Deleting...',
              );
            },
          ),
        );
      case InventoryDeleteSuccess(:final item):
        context.router.pop();
        showSnackBar(context, 'Item deleted successfully.');
        context.read<InventoryCategoryBloc>().add(
          InventoryCategoryEvent.itemRemoved(
            item: item,
          ),
        );
    }
  }

  Future<void> _handleEdit(InventoryItem item) async {
    final updatedItem = await context.router.push<InventoryItem>(
      InventoryEditRoute(
        item: item,
      ),
    );

    if (!mounted || updatedItem == null) return;

    context.read<InventoryCategoryBloc>().add(
      InventoryCategoryEvent.itemChanged(item: updatedItem),
    );
  }

  void _handleTap(InventoryItem item) {
    setState(() {
      _selectedItem = item;
    });

    scaffoldKey.currentState!.openEndDrawer();
  }
}
