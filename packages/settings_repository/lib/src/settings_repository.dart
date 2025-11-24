import 'dart:developer';
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

  /// Fetches the application settings from the backend.
  Future<Settings> fetchSettings() async {
    try {
      final document = await _appwrite.databases.getRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: '6920045a0029bf6c6dec',
      );
      return Settings.fromJson(document.data);
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'SettingsRepository.fetchSettings');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Updates the application settings in the backend.
  Future<Settings> updateSettings(Settings settings) async {
    try {
      final document = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: settings.id,
        data: settings.toJson(),
      );
      return Settings.fromJson(document.data);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Uploads the business logo file to the backend and returns its file ID.
  Future<String> uploadQr(File file) async {
    try {
      final fileId = await _appwrite.uploadFile(file);
      return fileId;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Uploads the QR code file to the backend and returns its file ID.
  Future<String> uploadBusinessLogo(File file) async {
    try {
      final fileId = await _appwrite.uploadFile(file);
      return fileId;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
