import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

/// {@template cache_repository}
/// Represents the cache repository.
/// {@endtemplate}
class CacheRepository {
  /// Initialize the singleton. Call once (e.g., in main()).
  factory CacheRepository.initialize() {
    if (_instance != null) return _instance!;
    _instance = const CacheRepository._();
    return _instance!;
  }

  /// {@macro cache_repository}
  const CacheRepository._();

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

  Future<String> get _tempPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// Write data to a file in the cache directory.
  Future<File> writeFileToCache(String fileName, List<int> data) async {
    final path = await _tempPath;
    final file = File('$path/$fileName');

    return file.writeAsBytes(data);
  }

  /// Read data from a file in the cache directory.
  ///
  /// Throws a [FileNotFound] exception if the file does not exist.
  Future<File?> readFileFromCache(String fileName) async {
    final path = await _tempPath;
    final file = File('$path/$fileName');

    if (file.existsSync()) {
      return file;
    }

    return null;
  }

}
