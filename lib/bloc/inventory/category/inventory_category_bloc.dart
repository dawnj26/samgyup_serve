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
    on<_Reload>(_onReload);
    on<_ItemRemoved>(_onItemRemoved);
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
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        category: state.category,
      );

      emit(
        InventoryCategoryLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          category: state.category,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryCategoryError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          category: state.category,
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
      );

      emit(
        InventoryCategoryLoaded(
          items: List.of(state.items)..addAll(items),
          hasReachedMax: items.length < _pageSize,
          category: state.category,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryCategoryError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          category: state.category,
        ),
      );
    }
  }

  Future<void> _onReload(
    _Reload event,
    Emitter<InventoryCategoryState> emit,
  ) async {
    // TODO(reload): Implement reload logic if needed.
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
      ),
    );
  }
}
