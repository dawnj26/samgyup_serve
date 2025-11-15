import 'package:formz/formz.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;

enum MeasurementUnitValidationError {
  empty,
}

class MeasurementUnitInput
    extends FormzInput<i.MeasurementUnit?, MeasurementUnitValidationError> {
  const MeasurementUnitInput.pure([super.value]) : super.pure();
  const MeasurementUnitInput.dirty([super.value]) : super.dirty();

  @override
  MeasurementUnitValidationError? validator(i.MeasurementUnit? value) {
    if (value == null) {
      return MeasurementUnitValidationError.empty;
    }

    return null;
  }
}
