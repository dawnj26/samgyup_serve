import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'menu_event.dart';
part 'menu_state.dart';
part 'menu_bloc.freezed.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({required MenuRepository menuRepository})
    : _menuRepository = menuRepository,
      super(const MenuInitial()) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<_Refresh>(_onRefresh);
    on<_FilterChanged>(
      _onFilterChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  final MenuRepository _menuRepository;
  final int _pageSize = 20;

  Future<void> _onStarted(_Started event, Emitter<MenuState> emit) async {
    emit(
      MenuLoading(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        menuInfo: state.menuInfo,
        selectedCategories: state.selectedCategories,
      ),
    );

    try {
      final items = await _menuRepository.fetchItems(
        category: event.initialCategories,
      );
      final menuInfo = await _menuRepository.fetchMenuInfo();

      emit(
        MenuLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          menuInfo: menuInfo,
          selectedCategories: event.initialCategories ?? [],
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuError(
          message: e.message,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    }
  }

  Future<void> _onLoadMore(_LoadMore event, Emitter<MenuState> emit) async {
    if (state.hasReachedMax) return;

    try {
      final items = await _menuRepository.fetchItems(
        limit: _pageSize,
        cursor: state.items.isNotEmpty ? state.items.last.id : null,
        category: state.selectedCategories,
      );

      emit(
        MenuLoaded(
          items: [...state.items, ...items],
          hasReachedMax: items.length < _pageSize,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuError(
          message: e.message,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    }
  }

  Future<void> _onRefresh(_Refresh event, Emitter<MenuState> emit) async {
    try {
      final items = await _menuRepository.fetchItems();
      final menuInfo = await _menuRepository.fetchMenuInfo();

      emit(
        MenuLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          menuInfo: menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuError(
          message: e.message,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: state.selectedCategories,
        ),
      );
    }
  }

  Future<void> _onFilterChanged(
    _FilterChanged event,
    Emitter<MenuState> emit,
  ) async {
    emit(
      MenuLoading(
        items: state.items,
        hasReachedMax: state.hasReachedMax,
        menuInfo: state.menuInfo,
        selectedCategories: event.selectedCategories,
      ),
    );

    try {
      final items = await _menuRepository.fetchItems(
        category: event.selectedCategories,
      );

      emit(
        MenuLoaded(
          items: items,
          hasReachedMax: items.length < _pageSize,
          menuInfo: state.menuInfo,
          selectedCategories: event.selectedCategories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuError(
          message: e.message,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: event.selectedCategories,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuError(
          message: e.toString(),
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          menuInfo: state.menuInfo,
          selectedCategories: event.selectedCategories,
        ),
      );
    }
  }
}
