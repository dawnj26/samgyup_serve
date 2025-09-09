import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'table_delete_event.dart';
part 'table_delete_state.dart';
part 'table_delete_bloc.freezed.dart';

class TableDeleteBloc extends Bloc<TableDeleteEvent, TableDeleteState> {
  TableDeleteBloc({required TableRepository tableRepository})
    : _repo = tableRepository,
      super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final TableRepository _repo;

  Future<void> _onStarted(
    _Started event,
    Emitter<TableDeleteState> emit,
  ) async {
    emit(state.copyWith(status: TableDeleteStatus.loading));
    try {
      await _repo.deleteTable(event.id);
      emit(state.copyWith(status: TableDeleteStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: TableDeleteStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: TableDeleteStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
