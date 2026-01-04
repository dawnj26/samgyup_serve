import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'category_bloc.freezed.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const CategoryState.initial()) {
    on<_Started>(_onStarted);
  }

  final InventoryRepository _inventoryRepository;

  FutureOr<void> _onStarted(_Started event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      final categories = await _inventoryRepository.fetchCategories();
      emit(
        state.copyWith(
          status: LoadingStatus.success,
          categories: categories,
        ),
      );
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
