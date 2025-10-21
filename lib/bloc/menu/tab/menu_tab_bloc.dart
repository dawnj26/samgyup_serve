import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_tab_event.dart';
part 'menu_tab_state.dart';
part 'menu_tab_bloc.freezed.dart';

class MenuTabBloc extends Bloc<MenuTabEvent, MenuTabState> {
  MenuTabBloc({
    required MenuRepository menuRepository,
    required MenuCategory category,
  }) : _menuRepo = menuRepository,
       _category = category,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_FetchMore>(_onFetchMore);
    on<_Refresh>(_onRefreshed);
  }

  final MenuCategory _category;
  final MenuRepository _menuRepo;
  final int _pageSize = 20;

  Future<void> _onRefreshed(
    _Refresh event,
    Emitter<MenuTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MenuTabStatus.refreshing));
      final items = await _menuRepo.fetchItems(
        category: [_category],
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MenuTabStatus.loading));
      final items = await _menuRepo.fetchItems(
        category: [_category],
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchMore(
    _FetchMore event,
    Emitter<MenuTabState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      emit(state.copyWith(status: MenuTabStatus.loading));
      final items = await _menuRepo.fetchItems(
        category: [_category],
        limit: _pageSize,
      );
      emit(
        state.copyWith(
          status: MenuTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
