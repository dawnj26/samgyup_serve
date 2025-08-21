import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/bloc/inventory/delete/inventory_delete_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/status/inventory_status_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/dialogs/loading_dialog.dart';
import 'package:samgyup_serve/ui/inventory/components/inventory_item_list.dart';
import 'package:samgyup_serve/ui/inventory/components/status_list_app_bar.dart';

class InventoryStatusListScreen extends StatefulWidget {
  const InventoryStatusListScreen({super.key});

  @override
  State<InventoryStatusListScreen> createState() =>
      _InventoryStatusListScreenState();
}

class _InventoryStatusListScreenState extends State<InventoryStatusListScreen> {
  final _scrollController = ScrollController();

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

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<InventoryStatusBloc>().add(
        const InventoryStatusEvent.loadMore(),
      );
    }
  }

  void _handleListener(BuildContext context, InventoryDeleteState state) {
    switch (state) {
      case InventoryDeleteLoading():
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (ctx) {
            return const LoadingDialog(
              message: 'Deleting...',
            );
          },
        );
      case InventoryDeleteSuccess(:final item):
        context.router.pop();
        showSnackBar(context, 'Item deleted successfully.');
        context.read<InventoryStatusBloc>().add(
          InventoryStatusEvent.itemRemoved(
            item: item,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryDeleteBloc, InventoryDeleteState>(
      listener: _handleListener,
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const StatusListAppBar(),
            BlocBuilder<InventoryStatusBloc, InventoryStatusState>(
              builder: (context, state) {
                switch (state) {
                  case InventoryStatusLoaded(:final items):
                    return InventoryItemList(
                      key: const Key('inventory_status_list'),
                      items: items,
                      hasReachedMax: state.hasReachedMax,
                      onEdit: (item) async {
                        final updatedItem = await context.router
                            .push<InventoryItem>(
                              InventoryEditRoute(
                                item: item,
                              ),
                            );

                        if (!context.mounted || updatedItem == null) return;
                        log('Item changed: ${item.name}');
                        context.read<InventoryStatusBloc>().add(
                          InventoryStatusEvent.itemChanged(item: updatedItem),
                        );
                      },
                    );
                  case InventoryStatusError(:final message):
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
      ),
    );
  }
}
