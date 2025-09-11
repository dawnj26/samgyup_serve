part of 'device_select_bloc.dart';

enum DeviceSelectStatus { initial, loading, success, failure }

@freezed
abstract class DeviceSelectState with _$DeviceSelectState {
  const factory DeviceSelectState.initial({
    @Default(DeviceSelectStatus.initial) DeviceSelectStatus status,
    @Default([]) List<Device> devices,
    @Default({}) Map<String, Table> tables,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _Initial;
}
