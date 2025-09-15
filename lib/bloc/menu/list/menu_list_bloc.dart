import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_list_event.dart';
part 'menu_list_state.dart';
part 'menu_list_bloc.freezed.dart';

class MenuListBloc extends Bloc<MenuListEvent, MenuListState> {
  MenuListBloc({
    required MenuRepository menuRepository,
    required List<String> menuIds,
  }) : _menuRepo = menuRepository,
       _menuIds = menuIds,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final MenuRepository _menuRepo;
  final List<String> _menuIds;

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuListState> emit,
  ) async {
    emit(state.copyWith(status: MenuListStatus.loading));
    try {
      final items = await _menuRepo.fetchItems(menuIds: _menuIds);
      emit(
        state.copyWith(
          status: MenuListStatus.success,
          items: items,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: MenuListStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: MenuListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
