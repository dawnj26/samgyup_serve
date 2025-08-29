import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'ingredient_edit_event.dart';
part 'ingredient_edit_state.dart';
part 'ingredient_edit_bloc.freezed.dart';

class IngredientEditBloc
    extends Bloc<IngredientEditEvent, IngredientEditState> {
  IngredientEditBloc({
    required MenuRepository menuRepository,
  }) : _menuRepository = menuRepository,
       super(const IngredientEditInitial()) {
    on<_Submitted>(_onSubmitted);
  }

  final MenuRepository _menuRepository;

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<IngredientEditState> emit,
  ) async {
    emit(const IngredientEditSaving());
    try {
      await _menuRepository.updateIngredients(
        ingredients: event.ingredients,
        menuId: event.menuId,
      );
      emit(const IngredientEditSaved());
    } on ResponseException catch (e) {
      emit(IngredientEditError(e.message));
    } on Exception catch (e) {
      emit(IngredientEditError(e.toString()));
    }
  }
}
