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

part 'menu_edit_event.dart';
part 'menu_edit_state.dart';
part 'menu_edit_bloc.freezed.dart';

class MenuEditBloc extends Bloc<MenuEditEvent, MenuEditState> {
  MenuEditBloc({
    required MenuRepository menuRepository,
    required this.menuItem,
  }) : _menuRepository = menuRepository,
       super(
         MenuEditInitial(
           name: Name.dirty(menuItem.name),
           description: MenuDescription.dirty(menuItem.description),
           price: Price.dirty(menuItem.price.toStringAsFixed(2)),
           category: MenuCategoryInput.dirty(menuItem.category),
         ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_PriceChanged>(_onPriceChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_Submitted>(_onSubmitted);
    on<_ImageChanged>(_onImageChanged);
  }

  final MenuRepository _menuRepository;
  final MenuItem menuItem;

  void _onNameChanged(
    _NameChanged event,
    Emitter<MenuEditState> emit,
  ) {
    final name = Name.dirty(event.name);
    emit(
      MenuEditChanged(
        name: name,
        description: state.description,
        price: state.price,
        category: state.category,
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
    Emitter<MenuEditState> emit,
  ) {
    final description = MenuDescription.dirty(event.description);
    emit(
      MenuEditChanged(
        name: state.name,
        description: description,
        price: state.price,
        category: state.category,
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
    Emitter<MenuEditState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      MenuEditChanged(
        name: state.name,
        description: state.description,
        price: price,
        category: state.category,
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
    Emitter<MenuEditState> emit,
  ) {
    final category = MenuCategoryInput.dirty(event.category);
    emit(
      MenuEditChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        category: category,
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

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<MenuEditState> emit,
  ) async {
    if (!state.isDetailsValid) return;

    try {
      final menu = menuItem.copyWith(
        name: state.name.value,
        description: state.description.value,
        price: double.parse(state.price.value),
        category: state.category.value!,
      );
      final isDirty = menu != menuItem || state.imageFile != null;

      if (!isDirty) {
        return emit(
          MenuEditPure(
            name: state.name,
            description: state.description,
            price: state.price,
            category: state.category,
            isDetailsValid: state.isDetailsValid,
            imageFile: state.imageFile,
          ),
        );
      }

      emit(
        MenuEditSubmitting(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
        ),
      );

      await _menuRepository.updateMenu(
        menu: menu,
        imageFile: state.imageFile,
      );

      emit(
        MenuEditSuccess(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuEditFailure(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuEditFailure(
          name: state.name,
          description: state.description,
          price: state.price,
          category: state.category,
          isDetailsValid: state.isDetailsValid,
          imageFile: state.imageFile,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onImageChanged(
    _ImageChanged event,
    Emitter<MenuEditState> emit,
  ) {
    emit(
      MenuEditChanged(
        name: state.name,
        description: state.description,
        price: state.price,
        category: state.category,
        isDetailsValid: state.isDetailsValid,
        imageFile: event.imageFile,
      ),
    );
  }
}
