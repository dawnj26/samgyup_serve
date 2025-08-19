import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/status/inventory_status_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';

class InventoryItemList extends StatefulWidget {
  const InventoryItemList({super.key});

  @override
  State<InventoryItemList> createState() => _InventoryItemListState();
}

class _InventoryItemListState extends State<InventoryItemList> {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryStatusBloc, InventoryStatusState>(
      builder: (context, state) {
        switch (state) {
          case InventoryStatusLoaded(:final items):
            return ListView.builder(
              controller: _scrollController,
              key: const Key('inventory_status_list'),
              itemBuilder: (ctx, index) {
                return index >= items.length
                    ? const BottomLoader()
                    : ListTile(
                        title: Text(items[index].name),
                      );
              },
              itemCount: state.hasReachedMax ? items.length : items.length + 1,
            );
          case InventoryStatusError(:final message):
            return Center(
              child: Text(
                'Error: $message',
                style: const TextStyle(color: Colors.red),
              ),
            );
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
