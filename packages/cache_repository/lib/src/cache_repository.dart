import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

/// {@template cache_repository}
/// Represents the cache repository.
/// {@endtemplate}
class CacheRepository {
  /// {@macro cache_repository}
  CacheRepository._({
    required String tempPath,
  }) : _tempPath = tempPath;

  /// Initialize the singleton. Call once (e.g., in main()).
  static Future<CacheRepository> initialize() async {
    if (_instance != null) return _instance!;
    final tempDir = await getTemporaryDirectory();
    _instance = CacheRepository._(tempPath: tempDir.path);
    return _instance!;
  }

  static CacheRepository? _instance;

  /// Global singleton instance. Throws if not initialized.
  static CacheRepository get instance {
    final inst = _instance;
    if (inst == null) {
      throw StateError(
        'CacheRepository has not been initialized.',
      );
    }
    return inst;
  }

  late final String _tempPath;

  /// Write data to a file in the cache directory.
  Future<File> writeFileToCache(String fileName, List<int> data) async {
    final path = _tempPath;
    final file = File('$path/$fileName');

    return file.writeAsBytes(data);
  }

  /// Read data from a file in the cache directory.
  File? readFileFromCache(String fileName) {
    final path = _tempPath;
    final file = File('$path/$fileName');

    if (file.existsSync()) {
      return file;
    }

    return null;
  }

  /// Get file extension from MIME type string.
  ///
  /// Returns the file extension (with dot) for the given MIME type.
  /// Returns null if no extension is found for the MIME type.
  String? getExtensionFromMimeType(String mimeType) {
    return extensionFromMime(mimeType);
  }
}
