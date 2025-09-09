part of 'tables_bloc.dart';

@freezed
class TablesEvent with _$TablesEvent {
  const factory TablesEvent.started() = _Started;
  const factory TablesEvent.refreshed() = _Refreshed;
  const factory TablesEvent.statusChanged(List<TableStatus> statuses) =
      _StatusChanged;
  const factory TablesEvent.loadedMore() = _LoadedMore;
}
