import 'package:formz/formz.dart';
import 'package:inventory_repository/inventory_repository.dart';

enum CategoryValidationError {
  empty,
}

class Category extends FormzInput<InventoryCategory?, CategoryValidationError> {
  const Category.pure() : super.pure(null);
  const Category.dirty([super.value]) : super.dirty();

  @override
  CategoryValidationError? validator(InventoryCategory? value) {
    if (value == null) {
      return CategoryValidationError.empty;
    }

    return null;
  }
}
