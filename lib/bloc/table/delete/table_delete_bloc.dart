import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/log_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'table_delete_event.dart';
part 'table_delete_state.dart';
part 'table_delete_bloc.freezed.dart';

class TableDeleteBloc extends Bloc<TableDeleteEvent, TableDeleteState> {
  TableDeleteBloc({
    required TableRepository tableRepository,
    required DeviceRepository deviceRepository,
  }) : _repo = tableRepository,
       _deviceRepo = deviceRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final TableRepository _repo;
  final DeviceRepository _deviceRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<TableDeleteState> emit,
  ) async {
    emit(state.copyWith(status: TableDeleteStatus.loading));
    try {
      final t = await _repo.fetchTable(event.id);
      await _repo.deleteTable(event.id);
      final device = await _deviceRepo.getDeviceByTable(event.id);
      if (device != null) {
        await _deviceRepo.updateDevice(
          device.copyWith(tableId: null),
        );
      }

      await LogRepository.instance.logAction(
        action: LogAction.delete,
        message: 'Table ${t.number} deleted',
        resourceId: t.id,
        details: 'Table ID: ${t.id}, Capacity: ${t.capacity}',
      );

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
