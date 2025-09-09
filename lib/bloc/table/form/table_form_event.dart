part of 'table_form_bloc.dart';

@freezed
class TableFormEvent with _$TableFormEvent {
  const factory TableFormEvent.tableNumberChanged(String value) =
      _TableNumberChanged;
  const factory TableFormEvent.capacityChanged(String value) = _CapacityChanged;
  const factory TableFormEvent.tableStatusChanged(TableStatus status) =
      _TableStatusChanged;
  const factory TableFormEvent.formSubmitted() = _FormSubmitted;
}
