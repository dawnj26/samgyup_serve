import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'inventory_details_event.dart';
part 'inventory_details_state.dart';
part 'inventory_details_bloc.freezed.dart';

class InventoryDetailsBloc
    extends Bloc<InventoryDetailsEvent, InventoryDetailsState> {
  InventoryDetailsBloc({
    required InventoryItem item,
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(
         _Initial(
           item: item,
         ),
       ) {
    on<_BatchRefreshed>(_onBatchRefreshed);
  }

  final InventoryRepository _inventoryRepository;

  Future<void> _onBatchRefreshed(
    _BatchRefreshed event,
    Emitter<InventoryDetailsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadingStatus.loading,
      ),
    );

    try {
      final batches = await _inventoryRepository.fetchBatches(
        itemId: state.item.id,
      );

      final updatedItem =
          (await _inventoryRepository.fetchItemById(
            state.item.id,
          )).copyWith(
            stockBatches: batches,
          );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
          item: updatedItem,
          isDirty: updatedItem != state.item,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (_) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: 'An unknown error occurred.',
        ),
      );
    }
  }
}
