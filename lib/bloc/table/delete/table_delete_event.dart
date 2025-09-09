part of 'table_delete_bloc.dart';

@freezed
abstract class TableDeleteEvent with _$TableDeleteEvent {
  const factory TableDeleteEvent.started({
    required String id,
  }) = _Started;
}
