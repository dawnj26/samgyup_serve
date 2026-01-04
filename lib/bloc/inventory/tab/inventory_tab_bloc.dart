import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'inventory_tab_bloc.freezed.dart';
part 'inventory_tab_event.dart';
part 'inventory_tab_state.dart';

class InventoryTabBloc extends Bloc<InventoryTabEvent, InventoryTabState> {
  InventoryTabBloc({
    required InventoryRepository inventoryRepository,
    required String category,
  }) : _inventoryRepo = inventoryRepository,
       _category = category,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_FetchMore>(_onFetchMore);
    on<_Refresh>(_onRefreshed);
    on<_SubcategoriesChanged>(
      _onSubcategoriesChanged,
      transformer: debounce(
        const Duration(milliseconds: 300),
      ),
    );
  }

  final String _category;
  final InventoryRepository _inventoryRepo;
  final int _pageSize = 20;

  Future<void> _onRefreshed(
    _Refresh event,
    Emitter<InventoryTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MenuTabStatus.refreshing));
      final items = await _inventoryRepo.fetchItems(
        categories: [_category],
        limit: _pageSize,
        includeBatches: true,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<InventoryTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MenuTabStatus.loading));
      final items = await _inventoryRepo.fetchItems(
        categories: [_category],
        limit: _pageSize,
        includeBatches: true,
      );
      final subcategories = await _inventoryRepo.fetchSubcategories(
        category: _category,
      );

      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
          subcategories: subcategories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchMore(
    _FetchMore event,
    Emitter<InventoryTabState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      emit(state.copyWith(status: MenuTabStatus.loading));
      final items = await _inventoryRepo.fetchItems(
        categories: [_category],
        limit: _pageSize,
        includeBatches: true,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onSubcategoriesChanged(
    _SubcategoriesChanged event,
    Emitter<InventoryTabState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedSubcategories: event.selectedSubcategories,
      ),
    );
    try {
      emit(state.copyWith(status: MenuTabStatus.loadingItems));
      final items = await _inventoryRepo.fetchItems(
        categories: [_category],
        subcategoryIds: event.selectedSubcategories.map((e) => e.id).toList(),
        limit: _pageSize,
        includeBatches: true,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
