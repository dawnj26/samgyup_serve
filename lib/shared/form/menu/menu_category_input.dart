import 'package:formz/formz.dart';
import 'package:menu_repository/menu_repository.dart';

enum MenuCategoryInputValidationError {
  empty,
}

class MenuCategoryInput
    extends FormzInput<MenuCategory?, MenuCategoryInputValidationError> {
  const MenuCategoryInput.pure([super.value]) : super.pure();
  const MenuCategoryInput.dirty([super.value]) : super.dirty();

  @override
  MenuCategoryInputValidationError? validator(MenuCategory? value) {
    if (value == null) {
      return MenuCategoryInputValidationError.empty;
    }
    return null;
  }
}
