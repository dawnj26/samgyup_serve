import 'package:formz/formz.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;

enum MeasurementUnitValidationError {
  empty,
}

class MeasurementUnit
    extends FormzInput<i.MeasurementUnit?, MeasurementUnitValidationError> {
  const MeasurementUnit.pure() : super.pure(null);
  const MeasurementUnit.dirty([super.value]) : super.dirty();

  @override
  MeasurementUnitValidationError? validator(i.MeasurementUnit? value) {
    if (value == null) {
      return MeasurementUnitValidationError.empty;
    }

    return null;
  }
}
