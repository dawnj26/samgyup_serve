import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_repository/src/exceptions/exceptions.dart';
import 'package:device_repository/src/models/models.dart';

/// {@template device_repository}
/// A Repository which manages device information.
/// {@endtemplate}
class DeviceRepository {
  /// {@macro device_repository}
  DeviceRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance,
       _devicePlugin = DeviceInfoPlugin();

  final AppwriteRepository _appwrite;
  final DeviceInfoPlugin _devicePlugin;

  String get _collectionId => _appwrite.environment.deviceCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;

  /// Adds a new device to the repository.
  Future<Device> addDevice() async {
    try {
      final device = await getDeviceInfo();

      final response = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: device.id,
        data: device.toJson(),
      );

      return Device.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Fetches device information based on the current device.
  Future<Device> getDevice() async {
    try {
      final id = await _getDeviceId();

      if (id == null) {
        throw DeviceNotSupported();
      }

      final response = await _appwrite.databases.getRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: id,
      );

      final json = _appwrite.rowToJson(response);

      return Device.fromJson(json);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  Future<String?> _getDeviceId() async {
    if (Platform.isAndroid) {
      final androidInfo = await _devicePlugin.androidInfo;
      return androidInfo.id;
    }

    return null;
  }

  /// Fetches detailed information about the current device.
  Future<Device> getDeviceInfo() async {
    final deviceInfo = await _devicePlugin.androidInfo;

    return Device(
      id: deviceInfo.id,
      model: deviceInfo.model,
      manufacturer: deviceInfo.manufacturer,
    );
  }
}
