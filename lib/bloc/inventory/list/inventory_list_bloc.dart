import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'inventory_list_event.dart';
part 'inventory_list_state.dart';
part 'inventory_list_bloc.freezed.dart';

class InventoryListBloc extends Bloc<InventoryListEvent, InventoryListState> {
  InventoryListBloc({
    required InventoryRepository inventoryRepository,
    List<InventoryCategory> categories = const [],
    List<String>? itemIds,
  }) : _inventoryRepository = inventoryRepository,
       _itemIds = itemIds,
       super(_Initial(categories: categories)) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<_Reload>(
      _onReload,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<_ItemRemoved>(_onItemRemoved);
    on<_ItemChanged>(_onItemChanged);
    on<_CategoriesChanged>(_onCategoriesChanged);
  }

  final InventoryRepository _inventoryRepository;
  final int _pageSize = 25;
  final List<String>? _itemIds;

  Future<void> _onStarted(
    _Started event,
    Emitter<InventoryListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadingStatus.loading,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        categories: state.categories,
        includeBatches: true,
        itemIds: _itemIds,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<InventoryListState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastItem = state.items.isNotEmpty ? state.items.last : null;
      final items = await _inventoryRepository.fetchItems(
        lastDocumentId: lastItem?.id,
        categories: state.categories,
        limit: _pageSize,
        includeBatches: true,
        itemIds: _itemIds,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          items: List.of(state.items)..addAll(items),
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          categories: state.categories,
        ),
      );
    }
  }

  Future<void> _onReload(
    _Reload event,
    Emitter<InventoryListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadingStatus.loading,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        categories: state.categories,
        includeBatches: true,
        itemIds: _itemIds,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<InventoryListState> emit,
  ) async {
    final items = state.items
        .where((item) => item.id != event.item.id)
        .toList();
    emit(
      state.copyWith(
        items: items,
      ),
    );
  }

  Future<void> _onItemChanged(
    _ItemChanged event,
    Emitter<InventoryListState> emit,
  ) async {
    final items = state.items.map((item) {
      return item.id == event.item.id ? event.item : item;
    }).toList();
    emit(
      state.copyWith(
        items: items,
      ),
    );
  }

  FutureOr<void> _onCategoriesChanged(
    _CategoriesChanged event,
    Emitter<InventoryListState> emit,
  ) {
    emit(
      state.copyWith(
        categories: event.categories,
      ),
    );
    add(const InventoryListEvent.reload());
  }
}
