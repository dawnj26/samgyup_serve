import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';

part 'inventory_delete_event.dart';
part 'inventory_delete_state.dart';
part 'inventory_delete_bloc.freezed.dart';

class InventoryDeleteBloc
    extends Bloc<InventoryDeleteEvent, InventoryDeleteState> {
  InventoryDeleteBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(
         InventoryDeleteInitial(
           item: InventoryItem.empty(),
         ),
       ) {
    on<_Started>(_onStarted);
  }

  final InventoryRepository _inventoryRepository;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<InventoryDeleteState> emit,
  ) async {
    final item = event.item;
    emit(InventoryDeleteLoading(item: item));

    try {
      await _inventoryRepository.deleteItem(event.item.id);
      await Future<void>.delayed(const Duration(milliseconds: 500));
      emit(
        InventoryDeleteSuccess(
          item: item,
        ),
      );
    } on Exception catch (e) {
      emit(InventoryDeleteError(message: e.toString(), item: item));
    }
  }
}
