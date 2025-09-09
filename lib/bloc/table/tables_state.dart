part of 'tables_bloc.dart';

enum TablesStatus { initial, loading, success, failure }

@freezed
abstract class TablesState with _$TablesState {
  const factory TablesState.initial({
    @Default(TablesStatus.initial) TablesStatus status,
    @Default([]) List<Table> tables,
    @Default(false) bool hasReachedMax,
    @Default([]) List<TableStatus> statuses,
    String? errorMessage,
    int? totalTables,
  }) = _Initial;
}
