part of 'table_availability_bloc.dart';

@freezed
class TableAvailabilityEvent with _$TableAvailabilityEvent {
  const factory TableAvailabilityEvent.started() = _Started;
}
