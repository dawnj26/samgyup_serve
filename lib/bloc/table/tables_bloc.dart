import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/stream.dart';
import 'package:table_repository/table_repository.dart';

part 'tables_event.dart';
part 'tables_state.dart';
part 'tables_bloc.freezed.dart';

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  TablesBloc({
    required TableRepository tableRepository,
  }) : _repo = tableRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_LoadedMore>(_onLoadedMore);
    on<_StatusChanged>(
      _onStatusChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  final TableRepository _repo;
  final int _pageSize = 20;

  Future<void> _onStarted(_Started event, Emitter<TablesState> emit) async {
    emit(state.copyWith(status: TablesStatus.loading));
    return _loadTables(emit: emit, refresh: true);
  }

  Future<void> _onRefreshed(_Refreshed event, Emitter<TablesState> emit) async {
    return _loadTables(emit: emit, statuses: state.statuses, refresh: true);
  }

  Future<void> _onStatusChanged(
    _StatusChanged event,
    Emitter<TablesState> emit,
  ) async {
    emit(
      state.copyWith(
        status: TablesStatus.loading,
      ),
    );
    return _loadTables(
      emit: emit,
      statuses: event.statuses,
      refresh: true,
    );
  }

  Future<void> _onLoadedMore(
    _LoadedMore event,
    Emitter<TablesState> emit,
  ) async {
    if (state.hasReachedMax) return;
    return _loadTables(
      emit: emit,
      lastId: state.tables.isNotEmpty ? state.tables.last.id : null,
      statuses: state.statuses,
    );
  }

  Future<void> _loadTables({
    required Emitter<TablesState> emit,
    String? lastId,
    List<TableStatus>? statuses,
    bool refresh = false,
  }) async {
    try {
      final tables = await _repo.fetchTables(
        limit: _pageSize,
        cursor: lastId,
        statuses: statuses ?? [],
      );
      final totalTables = refresh
          ? await _repo.getTotalTable()
          : state.totalTables;

      emit(
        state.copyWith(
          status: TablesStatus.success,
          tables: !refresh ? [...state.tables, ...tables] : tables,
          hasReachedMax: tables.length < _pageSize,
          totalTables: totalTables,
          statuses: statuses ?? state.statuses,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: TablesStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
