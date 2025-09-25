import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'table_availability_event.dart';
part 'table_availability_state.dart';
part 'table_availability_bloc.freezed.dart';

class TableAvailabilityBloc
    extends Bloc<TableAvailabilityEvent, TableAvailabilityState> {
  TableAvailabilityBloc({
    required TableRepository tableRepository,
  }) : _tableRepository = tableRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final TableRepository _tableRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<TableAvailabilityState> emit,
  ) async {
    emit(state.copyWith(status: TableAvailabilityStatus.loading));

    try {
      final tables = await _tableRepository.getTotalTable();
      final availableTables = await _tableRepository.getAvailableTable();
      emit(
        state.copyWith(
          status: TableAvailabilityStatus.success,
          availableTables: availableTables,
          totalTables: tables,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: TableAvailabilityStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: TableAvailabilityStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
