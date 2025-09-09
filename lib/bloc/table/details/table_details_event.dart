part of 'table_details_bloc.dart';

@freezed
class TableDetailsEvent with _$TableDetailsEvent {
  const factory TableDetailsEvent.started() = _Started;
  const factory TableDetailsEvent.changed() = _Changed;
}
