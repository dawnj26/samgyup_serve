part of 'device_select_bloc.dart';

@freezed
class DeviceSelectEvent with _$DeviceSelectEvent {
  const factory DeviceSelectEvent.started() = _Started;
  const factory DeviceSelectEvent.loadMore() = _LoadMore;
}
