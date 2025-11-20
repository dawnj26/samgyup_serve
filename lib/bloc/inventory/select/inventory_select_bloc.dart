import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'inventory_select_event.dart';
part 'inventory_select_state.dart';
part 'inventory_select_bloc.freezed.dart';

class InventorySelectBloc
    extends Bloc<InventorySelectEvent, InventorySelectState> {
  InventorySelectBloc({
    required InventoryRepository inventoryRepository,
    required List<InventoryItem> initialItems,
  }) : _inventoryRepository = inventoryRepository,
       super(
         _Initial(
           selectedItems: initialItems,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(
        const Duration(milliseconds: 300),
      ),
    );
    on<_ItemSelected>(_onItemSelected);
    on<_ItemRemoved>(_onItemRemoved);
    on<_Cleared>(_onCleared);
    on<_Saved>((event, emit) {
      emit(
        state.copyWith(
          status: InventorySelectStatus.finished,
        ),
      );
    });
  }

  final InventoryRepository _inventoryRepository;
  final int _pageSize = 20;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<InventorySelectState> emit,
  ) async {
    emit(
      state.copyWith(
        loadingStatus: LoadingStatus.loading,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        includeBatches: true,
      );

      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  FutureOr<void> _onLoadMore(
    _LoadMore event,
    Emitter<InventorySelectState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastDocId = state.items.isNotEmpty ? state.items.last.id : null;
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        lastDocumentId: lastDocId,
        includeBatches: true,
      );

      emit(
        state.copyWith(
          items: [...state.items, ...items],
          hasReachedMax: items.isEmpty,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  FutureOr<void> _onItemSelected(
    _ItemSelected event,
    Emitter<InventorySelectState> emit,
  ) {
    emit(
      state.copyWith(
        selectedItems: [...state.selectedItems, event.item],
      ),
    );
  }

  FutureOr<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<InventorySelectState> emit,
  ) {
    emit(
      state.copyWith(
        selectedItems: state.selectedItems
            .where((item) => item.id != event.inventoryItemId)
            .toList(),
      ),
    );
  }

  FutureOr<void> _onCleared(
    _Cleared event,
    Emitter<InventorySelectState> emit,
  ) {
    emit(
      state.copyWith(
        selectedItems: [],
      ),
    );
  }
}
