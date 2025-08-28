import 'dart:io';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/form/menu/menu_category_input.dart';
import 'package:samgyup_serve/shared/form/menu/menu_description.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';

part 'menu_create_event.dart';
part 'menu_create_state.dart';
part 'menu_create_bloc.freezed.dart';

class MenuCreateBloc extends Bloc<MenuCreateEvent, MenuCreateState> {
  MenuCreateBloc({
    required MenuRepository menuRepository,
  }) : _menuRepository = menuRepository,
       super(const MenuCreateInitial()) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_PriceChanged>(_onPriceChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_IngredientsChanged>(_onIngredientsChanged);
    on<_Submitted>(_onSubmitted);
    on<_ImageChanged>(_onImageChanged);
  }

  final MenuRepository _menuRepository;

  void _onNameChanged(
    _NameChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      MenuCreateChanged(
        name: name,
        description: state.description,
        price: state.price,
        category: state.category,
        ingredients: state.ingredients,
        imageFile: state.imageFile,
        isDetailsValid: Formz.validate([
          name,
          state.description,
          state.price,
          state.category,
        ]),
      ),
    );
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    final description = MenuDescription.dirty(event.description);
    emit(
      MenuCreateChanged(
        name: state.name,
        description: description,
        price: state.price,
        category: state.category,
        ingredients: state.ingredients,
        imageFile: state.imageFile,
        isDetailsValid: Formz.validate([
          state.name,
          description,
          state.price,
          state.category,
        ]),
      ),
    );
  }

  void _onPriceChanged(
    _PriceChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      MenuCreateChanged(
        name: state.name,
        description: state.description,
        price: price,
        category: state.category,
        ingredients: state.ingredients,
        imageFile: state.imageFile,
        isDetailsValid: Formz.validate([
          state.name,
          state.description,
          price,
          state.category,
        ]),
      ),
    );
  }

  void _onCategoryChanged(
    _CategoryChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    final category = MenuCategoryInput.dirty(event.category);
    emit(
      MenuCreateChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        category: category,
        ingredients: state.ingredients,
        imageFile: state.imageFile,
        isDetailsValid: Formz.validate([
          state.name,
          state.description,
          state.price,
          category,
        ]),
      ),
    );
  }

  void _onIngredientsChanged(
    _IngredientsChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    emit(
      MenuCreateChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        ingredients: event.ingredients,
        isDetailsValid: state.isDetailsValid,
        imageFile: state.imageFile,
      ),
    );
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<MenuCreateState> emit,
  ) async {
    if (!state.isDetailsValid) return;

    emit(
      MenuCreateSubmitting(
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        ingredients: state.ingredients,
        isDetailsValid: state.isDetailsValid,
        imageFile: state.imageFile,
      ),
    );

    try {
      final menu = MenuItem(
        name: state.name.value,
        description: state.description.value,
        price: double.parse(state.price.value),
        category: state.category.value!,
        createdAt: DateTime.now(),
      );

      await _menuRepository.addMenu(
        menu: menu,
        ingredients: state.ingredients,
        imageFile: state.imageFile,
      );

      emit(
        MenuCreateSuccess(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          ingredients: state.ingredients,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuCreateFailure(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          ingredients: state.ingredients,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuCreateFailure(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          ingredients: state.ingredients,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onImageChanged(
    _ImageChanged event,
    Emitter<MenuCreateState> emit,
  ) {
    emit(
      MenuCreateChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        ingredients: state.ingredients,
        isDetailsValid: state.isDetailsValid,
        imageFile: event.imageFile,
      ),
    );
  }
}
