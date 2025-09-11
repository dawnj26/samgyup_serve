import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'table_details_event.dart';
part 'table_details_state.dart';
part 'table_details_bloc.freezed.dart';

class TableDetailsBloc extends Bloc<TableDetailsEvent, TableDetailsState> {
  TableDetailsBloc({
    required TableRepository tableRepository,
    required DeviceRepository deviceRepository,
    required Table table,
  }) : _tableRepo = tableRepository,
       _deviceRepo = deviceRepository,
       super(
         _Initial(
           table: table,
         ),
       ) {
    on<_Changed>(_onRefreshed);
    on<_Started>(_onStarted);
  }

  final TableRepository _tableRepo;
  final DeviceRepository _deviceRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<TableDetailsState> emit,
  ) async {
    emit(state.copyWith(status: TableDetailsStatus.loading));

    try {
      final device = await _deviceRepo.getDeviceByTable(state.table.id);

      emit(
        state.copyWith(
          status: TableDetailsStatus.success,
          device: device,
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

  Future<void> _onRefreshed(
    _Changed event,
    Emitter<TableDetailsState> emit,
  ) async {
    try {
      final updatedTable = await _tableRepo.fetchTable(state.table.id);

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
