import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'category_delete_event.dart';
part 'category_delete_state.dart';
part 'category_delete_bloc.freezed.dart';

class CategoryDeleteBloc
    extends Bloc<CategoryDeleteEvent, CategoryDeleteState> {
  CategoryDeleteBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final InventoryRepository _inventoryRepository;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<CategoryDeleteState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final tasks = event.items.map(
        (item) => _inventoryRepository.updateItem(
          item.copyWith(category: InventoryCategory.unknown.name),
        ),
      );

      await Future.wait(tasks);
      await _inventoryRepository.deleteCategory(
        event.categoryId,
      );

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
