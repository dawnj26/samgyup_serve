import 'package:formz/formz.dart';
import 'package:table_repository/table_repository.dart';

enum TableStatusInputValidationError {
  empty,
}

extension TableStatusInputValidationErrorX on TableStatusInputValidationError {
  String get message {
    switch (this) {
      case TableStatusInputValidationError.empty:
        return 'Table status is required.';
    }
  }
}

class TableStatusInput
    extends FormzInput<TableStatus?, TableStatusInputValidationError> {
  const TableStatusInput.pure([super.value]) : super.pure();
  const TableStatusInput.dirty([super.value]) : super.dirty();

  @override
  TableStatusInputValidationError? validator(TableStatus? value) {
    if (value == null) {
      return TableStatusInputValidationError.empty;
    }

    return null;
  }
}
