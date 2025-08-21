import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'inventory_status_event.dart';
part 'inventory_status_state.dart';
part 'inventory_status_bloc.freezed.dart';

class InventoryStatusBloc
    extends Bloc<InventoryStatusEvent, InventoryStatusState> {
  InventoryStatusBloc({
    required InventoryRepository inventoryRepository,
    InventoryItemStatus? status,
  }) : _inventoryRepository = inventoryRepository,
       super(
         InventoryStatusInitial(
           status: status,
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
    Emitter<InventoryStatusState> emit,
  ) async {
    emit(
      InventoryStatusLoading(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        status: state.status,
      ),
    );

    try {
      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
        status: state.status,
      );

      emit(
        InventoryStatusLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          status: state.status,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryStatusError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          status: state.status,
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<InventoryStatusState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastItem = state.items.isNotEmpty ? state.items.last : null;
      final items = await _inventoryRepository.fetchItems(
        lastDocumentId: lastItem?.id,
        status: state.status,
        limit: _pageSize,
      );

      emit(
        InventoryStatusLoaded(
          items: List.of(state.items)..addAll(items),
          hasReachedMax: items.length < _pageSize,
          status: state.status,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryStatusError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          status: state.status,
        ),
      );
    }
  }

  Future<void> _onReload(
    _Reload event,
    Emitter<InventoryStatusState> emit,
  ) async {
    // TODO(reload): Implement reload logic if needed.
  }

  Future<void> _onItemRemoved(
    _ItemRemoved event,
    Emitter<InventoryStatusState> emit,
  ) async {
    final items = state.items
        .where((item) => item.id != event.item.id)
        .toList();
    emit(
      InventoryStatusLoaded(
        items: items,
        hasReachedMax: state.hasReachedMax,
        status: state.status,
      ),
    );
  }
}
