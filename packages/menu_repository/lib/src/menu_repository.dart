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

}
