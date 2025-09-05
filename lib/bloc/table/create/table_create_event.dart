part of 'table_create_bloc.dart';

@freezed
class TableCreateEvent with _$TableCreateEvent {
  const factory TableCreateEvent.tableNumberChanged(String value) =
      _TableNumberChanged;
  const factory TableCreateEvent.capacityChanged(String value) =
      _CapacityChanged;
  const factory TableCreateEvent.tableStatusChanged(TableStatus status) =
      _TableStatusChanged;
  const factory TableCreateEvent.formSubmitted() = _FormSubmitted;
}
