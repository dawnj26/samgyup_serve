import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_details_event.dart';
part 'menu_details_state.dart';
part 'menu_details_bloc.freezed.dart';

class MenuDetailsBloc extends Bloc<MenuDetailsEvent, MenuDetailsState> {
  MenuDetailsBloc({
    required MenuRepository menuRepository,
    required MenuItem menuItem,
  }) : _menuRepository = menuRepository,
       super(
         MenuDetailsInitial(
           menuItem: menuItem,
         ),
       ) {
    on<_Started>(_onStarted);
  }

  final MenuRepository _menuRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuDetailsState> emit,
  ) async {
    emit(
      MenuDetailsState.loading(
        menuItem: state.menuItem,
        ingredients: state.ingredients,
        isDirty: state.isDirty,
      ),
    );

    try {
      final ingredients = await _menuRepository.fetchIngredients(
        state.menuItem.id,
      );

      emit(
        MenuDetailsState.loaded(
          menuItem: state.menuItem,
          ingredients: ingredients,
          isDirty: state.isDirty,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.message,
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.toString(),
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          isDirty: state.isDirty,
        ),
      );
    }
  }
}
