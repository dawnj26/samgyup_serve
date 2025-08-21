import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';
part 'inventory_bloc.freezed.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(
         InventoryInitial(
           inventoryInfo: InventoryInfo.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Reload>(_onReload);
  }

  final InventoryRepository _inventoryRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      final inventoryInfo = await _inventoryRepository.getInventoryInfo();
      emit(InventoryLoaded(inventoryInfo: inventoryInfo));
    } on Exception catch (e) {
      emit(
        InventoryError(
          inventoryInfo: state.inventoryInfo,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> _onReload(
    _Reload event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      final inventoryInfo = await _inventoryRepository.getInventoryInfo();
      emit(InventoryLoaded(inventoryInfo: inventoryInfo));
    } on Exception catch (e) {
      emit(
        InventoryError(
          inventoryInfo: state.inventoryInfo,
          message: e.toString(),
        ),
      );
    }
  }
}
