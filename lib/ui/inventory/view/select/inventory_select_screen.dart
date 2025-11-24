import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/inventory/select/inventory_select_bloc.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/components/bottom_loader.dart';
import 'package:samgyup_serve/ui/components/layouts/infinite_scroll_layout.dart';
import 'package:samgyup_serve/ui/inventory/components/components.dart';

class InventorySelectScreen extends StatelessWidget {
  const InventorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Items'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: kIsWeb ? 1200 : double.infinity,
          ),
          child: BlocBuilder<InventorySelectBloc, InventorySelectState>(
            builder: (context, state) {
              switch (state.loadingStatus) {
                case LoadingStatus.initial || LoadingStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case LoadingStatus.failure:
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'An unknown error occurred',
                    ),
                  );
                case LoadingStatus.success:
                  if (state.items.isEmpty) {
                    return const Center(
                      child: Text('No inventory items found.'),
                    );
                  }

                  final items = state.items;
                  final hasReachedMax = state.hasReachedMax;

                  return InfiniteScrollLayout(
                    onLoadMore: () => context.read<InventorySelectBloc>().add(
                      const InventorySelectEvent.loadMore(),
                    ),
                    slivers: [
                      SliverList.builder(
                        itemBuilder: (context, index) {
                          if (index >= items.length) {
                            return const BottomLoader();
                          }

                          final item = items[index];
                          final isSelected = state.selectedItems.any(
                            (selectedItem) => selectedItem.id == item.id,
                          );

                          return InventoryListItem(
                            item: item,
                            color: isSelected
                                ? colorScheme.primaryContainer.withValues(
                                    alpha: 0.7,
                                  )
                                : null,
                            onTap: () {
                              if (isSelected) {
                                context.read<InventorySelectBloc>().add(
                                  InventorySelectEvent.itemRemoved(item.id),
                                );
                              } else {
                                context.read<InventorySelectBloc>().add(
                                  InventorySelectEvent.itemSelected(item),
                                );
                              }
                            },
                          );
                        },
                        itemCount: hasReachedMax
                            ? items.length
                            : items.length + 1,
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<InventorySelectBloc>().add(
            const InventorySelectEvent.saved(),
          );
        },
        label: const Text('Save'),
        icon: const Icon(Icons.check),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final selectedItems = context.select(
            (InventorySelectBloc bloc) => bloc.state.selectedItems,
          );

          if (selectedItems.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            color: colorScheme.secondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${selectedItems.length} selected items'),
                TextButton(
                  onPressed: () {
                    context.read<InventorySelectBloc>().add(
                      const InventorySelectEvent.cleared(),
                    );
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
