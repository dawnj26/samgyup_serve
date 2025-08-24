import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:cache_repository/cache_repository.dart';

/// {@template menu_repository}
/// Repository package for managing menu data.
/// {@endtemplate}
class MenuRepository {
  /// {@macro menu_repository}
  MenuRepository({
    AppwriteRepository? appwrite,
    CacheRepository? cache,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance,
       _cache = cache ?? CacheRepository.instance;

  final AppwriteRepository _appwrite;
  final CacheRepository _cache;

  /// Gets image data of a menu item
  Future<File> getMenuItemImage(String fileId) async {
    try {
      final meta = await _appwrite.getFileMetadata(fileId);
      final fileType = _cache.getExtensionFromMimeType(meta.mimeType);

      if (fileType == null) {
        throw Exception('Unsupported file type: ${meta.mimeType}');
      }

      final filename = '$fileId.$fileType';
      final file = await _cache.readFileFromCache(filename);

      if (file != null) return file;

      final data = await _appwrite.downloadFile(fileId);
      return _cache.writeFileToCache(filename, data);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
