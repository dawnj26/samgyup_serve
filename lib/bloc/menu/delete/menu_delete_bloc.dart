import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_delete_event.dart';
part 'menu_delete_state.dart';
part 'menu_delete_bloc.freezed.dart';

class MenuDeleteBloc extends Bloc<MenuDeleteEvent, MenuDeleteState> {
  MenuDeleteBloc({
    required MenuRepository menuRepository,
  }) : _menuRepository = menuRepository,
       super(const MenuDeleteInitial()) {
    on<_Started>(_onStarted);
  }

  final MenuRepository _menuRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuDeleteState> emit,
  ) async {
    emit(const MenuDeleteState.deleting());

    try {
      await _menuRepository.deleteMenu(event.menuId);
      emit(const MenuDeleteState.success());
    } on Exception catch (e) {
      emit(MenuDeleteState.error(e.toString()));
    }
  }
}
