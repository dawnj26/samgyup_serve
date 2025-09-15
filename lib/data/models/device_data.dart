import 'package:device_repository/device_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/table_repository.dart';

part 'device_data.freezed.dart';

@freezed
abstract class DeviceData with _$DeviceData {
  factory DeviceData({
    required Device device,
    Table? table,
  }) = _DeviceData;
}
