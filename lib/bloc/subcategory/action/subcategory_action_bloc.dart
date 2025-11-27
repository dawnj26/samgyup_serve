import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:log_repository/log_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'subcategory_action_event.dart';
part 'subcategory_action_state.dart';
part 'subcategory_action_bloc.freezed.dart';

class SubcategoryActionBloc
    extends Bloc<SubcategoryActionEvent, SubcategoryActionState> {
  SubcategoryActionBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Created>(_onCreate);
    on<_Removed>(_onRemoved);
  }

  final InventoryRepository _inventoryRepository;

  Future<void> _onCreate(
    _Created event,
    Emitter<SubcategoryActionState> emit,
  ) async {
    emit(
      state.copyWith(
        actionType: SubcategoryActionType.create,
        status: LoadingStatus.loading,
      ),
    );

    try {
      final sub = await _inventoryRepository.addSubcategory(
        category: event.category,
        subcategory: event.name,
      );

      await LogRepository.instance.logAction(
        action: LogAction.create,
        message: 'Subcategory ${event.name} created',
        resourceId: sub.id,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  FutureOr<void> _onRemoved(
    _Removed event,
    Emitter<SubcategoryActionState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadingStatus.loading,
        actionType: SubcategoryActionType.remove,
      ),
    );

    try {
      final sub = await _inventoryRepository.fetchSubcategory(id: event.id);
      await _inventoryRepository.removeSubcategory(
        subcategoryId: event.id,
      );

      final message = sub != null
          ? 'Subcategory ${sub.name} removed'
          : 'Subcategory removed';

      await LogRepository.instance.logAction(
        action: LogAction.delete,
        message: message,
        resourceId: event.id,
        details: sub != null ? 'Subcategory ID: ${sub.id}' : null,
      );

      emit(
        state.copyWith(
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
