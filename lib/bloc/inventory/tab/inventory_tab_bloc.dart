import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';

part 'inventory_tab_event.dart';
part 'inventory_tab_state.dart';
part 'inventory_tab_bloc.freezed.dart';

class InventoryTabBloc extends Bloc<InventoryTabEvent, InventoryTabState> {
  InventoryTabBloc({
    required InventoryRepository inventoryRepository,
    required InventoryCategory category,
  }) : _inventoryRepo = inventoryRepository,
       _category = category,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_FetchMore>(_onFetchMore);
    on<_Refresh>(_onRefreshed);
  }

  final InventoryCategory _category;
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
}
