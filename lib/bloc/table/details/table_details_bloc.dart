import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'table_details_event.dart';
part 'table_details_state.dart';
part 'table_details_bloc.freezed.dart';

class TableDetailsBloc extends Bloc<TableDetailsEvent, TableDetailsState> {
  TableDetailsBloc({
    required TableRepository tableRepository,
    required Table table,
  }) : _repo = tableRepository,
       super(
         _Initial(
           table: table,
         ),
       ) {
    on<_Changed>(_onRefreshed);
  }

  final TableRepository _repo;

  Future<void> _onRefreshed(
    _Changed event,
    Emitter<TableDetailsState> emit,
  ) async {
    try {
      final updatedTable = await _repo.fetchTable(state.table.id);

      emit(
        state.copyWith(
          table: updatedTable,
          isDirty: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: TableDetailsStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
