import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'inventory_category_event.dart';
part 'inventory_category_state.dart';
part 'inventory_category_bloc.freezed.dart';

class InventoryCategoryBloc
    extends Bloc<InventoryCategoryEvent, InventoryCategoryState> {
  InventoryCategoryBloc({
    required InventoryRepository inventoryRepository,
    InventoryCategory category = InventoryCategory.meats,
  }) : _inventoryRepository = inventoryRepository,
       super(
         InventoryCategoryInitial(
           category: category,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(
        const Duration(milliseconds: 300),
      ),
    );
    on<_Reload>(
      _onReload,
      transformer: debounce(
        const Duration(milliseconds: 300),
      ),
    );
    on<_ItemRemoved>(_onItemRemoved);
    on<_ItemChanged>(_onItemChanged);
    on<_SubcategoryChanged>(_onSubcategoryChanged);
  }

  final InventoryRepository _inventoryRepository;
  final int _pageSize = 25;

  Future<void> _onStarted(
    _Started event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    emit(
      InventoryCategoryLoading(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        category: state.category,
        subcategories: state.subcategories,
        selectedSubcategories: state.selectedSubcategories,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        category: state.category,
        includeBatches: true,
      );
      final subcategories = await _inventoryRepository.fetchSubcategories(
        category: state.category,
      );

      emit(
        InventoryCategoryLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          category: state.category,
          subcategories: subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryCategoryError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          category: state.category,
          subcategories: state.subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastItem = state.items.isNotEmpty ? state.items.last : null;
      final items = await _inventoryRepository.fetchItems(
        lastDocumentId: lastItem?.id,
        category: state.category,
        limit: _pageSize,
        subcategoryIds: state.subcategories.map((e) => e.id).toList(),
        includeBatches: true,
      );

      emit(
        InventoryCategoryLoaded(
          items: List.of(state.items)..addAll(items),
          hasReachedMax: items.length < _pageSize,
          category: state.category,
          subcategories: state.subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryCategoryError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          category: state.category,
          subcategories: state.subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    }
  }

  Future<void> _onReload(
    _Reload event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    emit(
      InventoryCategoryLoadingItems(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        category: state.category,
        subcategories: state.subcategories,
        selectedSubcategories: state.selectedSubcategories,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        category: state.category,
        subcategoryIds: state.selectedSubcategories.map((e) => e.id).toList(),
        includeBatches: true,
      );

      emit(
        InventoryCategoryLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          category: state.category,
          subcategories: state.subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryCategoryError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          category: state.category,
          subcategories: state.subcategories,
          selectedSubcategories: state.selectedSubcategories,
        ),
      );
    }
  }

  Future<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    final items = state.items
        .where((item) => item.id != event.item.id)
        .toList();
    emit(
      InventoryCategoryLoaded(
        items: items,
        hasReachedMax: state.hasReachedMax,
        category: state.category,
        subcategories: state.subcategories,
        selectedSubcategories: state.selectedSubcategories,
      ),
    );
  }

  Future<void> _onItemChanged(
    _ItemChanged event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    final items = state.items.map((item) {
      return item.id == event.item.id ? event.item : item;
    }).toList();
    emit(
      InventoryCategoryLoaded(
        items: items,
        hasReachedMax: state.hasReachedMax,
        category: state.category,
        subcategories: state.subcategories,
        selectedSubcategories: state.selectedSubcategories,
      ),
    );
  }

  FutureOr<void> _onSubcategoryChanged(
    _SubcategoryChanged event,
    Emitter<InventoryCategoryState> emit,
  ) {
    emit(
      InventoryCategoryLoaded(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        category: state.category,
        subcategories: state.subcategories,
        selectedSubcategories: event.subcategories,
      ),
    );
    add(const InventoryCategoryEvent.reload());
  }
}
