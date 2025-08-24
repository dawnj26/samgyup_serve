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

}
