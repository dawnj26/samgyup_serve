import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'category_form_event.dart';
part 'category_form_state.dart';
part 'category_form_bloc.freezed.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc({
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Created>(_onCreated);
    on<_Updated>(_onUpdated);
  }

  final InventoryRepository _inventoryRepository;

  FutureOr<void> _onCreated(
    _Created event,
    Emitter<CategoryFormState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await _inventoryRepository.createCategory(
        name: event.name,
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

  FutureOr<void> _onUpdated(
    _Updated event,
    Emitter<CategoryFormState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      await _inventoryRepository.updateCategory(
        MainCategory(id: event.id, name: event.name),
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
