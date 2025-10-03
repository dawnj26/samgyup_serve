import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:settings_repository/src/models/models.dart';

/// {@template settings_repository}
/// A repository which manages application settings.
/// {@endtemplate}
class SettingsRepository {
  /// {@macro settings_repository}
  SettingsRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.settingsCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;

  /// Fetches all settings from the Appwrite database.
  Future<List<Setting>> getSettings() async {
    try {
      final documents = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
      );
      return documents.rows
          .map((e) => Setting.fromJson(_appwrite.rowToJson(e)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Updates the QR code setting with a new file.
  Future<Setting> updateQrSetting(File file, Setting qrSetting) async {
    try {
      final upload = await _appwrite.uploadFile(file);
      final u = qrSetting.copyWith(value: upload);

      final updatedRow = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: u.id,
        data: u.toJson(),
      );
      return Setting.fromJson(_appwrite.rowToJson(updatedRow));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves the file ID of the QR code setting.
  Future<String?> getQrFileId() async {
    try {
      final document = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('name', 'qr_code'),
          Query.limit(1),
        ],
      );
      if (document.total == 0) return null;

      final setting = Setting.fromJson(
        _appwrite.rowToJson(document.rows.first),
      );

      return setting.value;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
