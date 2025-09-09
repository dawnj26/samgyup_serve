import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'menu_select_bloc.freezed.dart';
part 'menu_select_event.dart';
part 'menu_select_state.dart';

class MenuSelectBloc extends Bloc<MenuSelectEvent, MenuSelectState> {
  MenuSelectBloc({
    required MenuRepository menuRepository,
    required List<MenuItem> initialSelectedItems,
  }) : _menuRepository = menuRepository,
       super(
         MenuSelectInitial(
           selectedItems: initialSelectedItems,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(const Duration(milliseconds: 300)),
    );
    on<_ItemToggled>(_onItemToggled);
    on<_Saved>(_onSaved);
    on<_SelectedItemsChanged>(_onSelectedItemsChanged);
  }

  final MenuRepository _menuRepository;
  final int _itemsPerPage = 20;

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuSelectState> emit,
  ) async {
    emit(
      MenuSelectLoading(
        items: state.items,
        selectedItems: state.selectedItems,
        hasReachedMax: state.hasReachedMax,
      ),
    );
    try {
      final items = await _menuRepository.fetchItems(
        limit: _itemsPerPage,
      );

      emit(
        MenuSelectSuccess(
          items: items,
          selectedItems: state.selectedItems,
          hasReachedMax: items.length < _itemsPerPage,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuSelectFailure(
          items: state.items,

          selectedItems: state.selectedItems,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuSelectFailure(
          items: state.items,

          selectedItems: state.selectedItems,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<MenuSelectState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      final lastDocumentId = state.items.isNotEmpty
          ? state.items.last.id
          : null;
      final items = await _menuRepository.fetchItems(
        limit: _itemsPerPage,
        cursor: lastDocumentId,
      );

      emit(
        MenuSelectSuccess(
          items: [...state.items, ...items],
          selectedItems: state.selectedItems,
          hasReachedMax: items.length < _itemsPerPage,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuSelectFailure(
          items: state.items,
          selectedItems: state.selectedItems,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuSelectFailure(
          items: state.items,
          selectedItems: state.selectedItems,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onItemToggled(
    _ItemToggled event,
    Emitter<MenuSelectState> emit,
  ) {
    final updatedSelectedItems = event.isSelected
        ? state.selectedItems.where((item) => item != event.item).toList()
        : [...state.selectedItems, event.item];
    emit(
      MenuSelectSuccess(
        items: state.items,
        selectedItems: updatedSelectedItems,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }

  void _onSaved(
    _Saved event,
    Emitter<MenuSelectState> emit,
  ) {
    emit(
      MenuSelectDone(
        items: state.items,
        selectedItems: state.selectedItems,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }

  void _onSelectedItemsChanged(
    _SelectedItemsChanged event,
    Emitter<MenuSelectState> emit,
  ) {
    emit(
      MenuSelectSuccess(
        items: state.items,
        selectedItems: event.items,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }
}
