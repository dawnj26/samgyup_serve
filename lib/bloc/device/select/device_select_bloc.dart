import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_select_event.dart';
part 'device_select_state.dart';
part 'device_select_bloc.freezed.dart';

class DeviceSelectBloc extends Bloc<DeviceSelectEvent, DeviceSelectState> {
  DeviceSelectBloc({
    required DeviceRepository deviceRepository,
  }) : _repo = deviceRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_LoadMore>(_onLoadMore);
  }

  final DeviceRepository _repo;
  final int _pageSize = 20;

  Future<void> _onStarted(
    _Started event,
    Emitter<DeviceSelectState> emit,
  ) async {
    emit(state.copyWith(status: DeviceSelectStatus.loading));
    try {
      final devices = await _repo.getAllDevices();
      emit(
        state.copyWith(
          status: DeviceSelectStatus.success,
          devices: devices,
          hasReachedMax: devices.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: DeviceSelectStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: DeviceSelectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<DeviceSelectState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }

    try {
      final devices = await _repo.getAllDevices(
        cursor: state.devices.isNotEmpty ? state.devices.last.id : null,
      );
      emit(
        state.copyWith(
          status: DeviceSelectStatus.success,
          devices: [...state.devices, ...devices],
          hasReachedMax: devices.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: DeviceSelectStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: DeviceSelectStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
