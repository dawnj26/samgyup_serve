import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'batch_delete_event.dart';
part 'batch_delete_state.dart';
part 'batch_delete_bloc.freezed.dart';

class BatchDeleteBloc extends Bloc<BatchDeleteEvent, BatchDeleteState> {
  BatchDeleteBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final InventoryRepository _inventoryRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<BatchDeleteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await _inventoryRepository.deleteBatch(event.batch.id);
      final item = await _inventoryRepository.fetchItemById(
        event.batch.itemId,
        includeBatch: true,
      );

      await _inventoryRepository.syncItem(item);

      emit(state.copyWith(status: LoadingStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
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
}
