import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:table_repository/table_repository.dart';

part 'table_details_event.dart';
part 'table_details_state.dart';
part 'table_details_bloc.freezed.dart';

class TableDetailsBloc extends Bloc<TableDetailsEvent, TableDetailsState> {
  TableDetailsBloc({
    required TableRepository tableRepository,
    required DeviceRepository deviceRepository,
    required ReservationRepository reservationRepository,
    required Table table,
  }) : _tableRepo = tableRepository,
       _deviceRepo = deviceRepository,
       _reservationRepo = reservationRepository,
       super(
         _Initial(
           table: table,
         ),
       ) {
    on<_Changed>(_onRefreshed);
    on<_Started>(_onStarted);
    on<_Assigned>(_onAssigned);
    on<_Unassigned>(_onUnassigned);
  }

  final TableRepository _tableRepo;
  final DeviceRepository _deviceRepo;
  final ReservationRepository _reservationRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<TableDetailsState> emit,
  ) async {
    emit(state.copyWith(status: TableDetailsStatus.loading));

    try {
      final device = await _deviceRepo.getDeviceByTable(state.table.id);
      final reservation = await _reservationRepo.getCurrentReservation(
        state.table.id,
      );

      emit(
        state.copyWith(
          status: TableDetailsStatus.success,
          device: device,
          reservationId: reservation?.id,
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

  Future<void> _onAssigned(
    _Assigned event,
    Emitter<TableDetailsState> emit,
  ) async {
    emit(state.copyWith(assignmentStatus: TableAssignmentStatus.assigning));

    try {
      final device = event.device;

      await Future<void>.delayed(const Duration(seconds: 1));
      final updatedDevice = await _deviceRepo.updateDevice(
        device.copyWith(tableId: state.table.id),
      );

      emit(
        state.copyWith(
          assignmentStatus: TableAssignmentStatus.success,
          device: updatedDevice,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          assignmentStatus: TableAssignmentStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> _onUnassigned(
    _Unassigned event,
    Emitter<TableDetailsState> emit,
  ) async {
    emit(state.copyWith(assignmentStatus: TableAssignmentStatus.unassigning));

    try {
      final device = event.device;

      await Future<void>.delayed(const Duration(seconds: 1));
      await _deviceRepo.updateDevice(
        device.copyWith(tableId: null),
      );

      emit(
        state.copyWith(
          assignmentStatus: TableAssignmentStatus.success,
          device: null,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          assignmentStatus: TableAssignmentStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
  }
}
