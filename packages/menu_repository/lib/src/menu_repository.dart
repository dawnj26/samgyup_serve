import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:cache_repository/cache_repository.dart';
import 'package:menu_repository/menu_repository.dart';

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

  ProjectInfo get _projectInfo => _appwrite.getProjectInfo();

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

  /// Adds a new menu item along with its ingredients.
  Future<void> addMenu({
    required MenuItem menu,
    required List<Ingredient> ingredients,
    File? imageFile,
  }) async {
    try {
      String? imageId;
      if (imageFile != null) {
        imageId = await _appwrite.uploadFile(imageFile);
      }

      final m = menu.copyWith(
        id: ID.unique(),
        imageId: imageId,
      );

      final menuDocument = await _appwrite.databases.createDocument(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.menuCollectionId,
        documentId: m.id,
        data: m.toJson(),
      );

      for (final ingredient in ingredients) {
        await _addIngredient(ingredient, menuDocument.$id);
      }
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  Future<void> _addIngredient(
    Ingredient ingredients,
    String menuItemId,
  ) async {
    try {
      final ingredient = ingredients.copyWith(
        menuItemId: menuItemId,
        id: ID.unique(),
      );
      await _appwrite.databases.createDocument(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.menuIngredientsCollectionId,
        documentId: ingredient.id,
        data: ingredient.toJson(),
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
