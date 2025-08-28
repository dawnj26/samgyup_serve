import 'dart:io';
import 'dart:isolate';

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
  String get _availabilityEndpoint =>
      'https://68aed0320022a720ec79.syd.appwrite.run';

  /// Gets image data of a menu item
  Future<File> getMenuItemImage(String filename) async {
    try {
      final file = await _cache.readFileFromCache(filename);

      if (file != null) return file;

      final id = _getFileId(filename);
      final data = await _appwrite.downloadFile(id);

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
      String? imageFileName;
      if (imageFile != null) {
        imageFileName = await _appwrite.uploadFile(imageFile);
      }

      final m = menu.copyWith(
        id: ID.unique(),
        imageFileName: imageFileName,
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

      await _checkMenuAvailability(m.id);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches a list of menu items with optional filtering by category.
  Future<List<MenuItem>> fetchItems({
    List<MenuCategory>? category,
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final documents = await _appwrite.databases.listDocuments(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.menuCollectionId,
        queries: [
          if (category != null && category.isNotEmpty)
            Query.equal('category', category.map((e) => e.name).toList()),
          Query.limit(limit),
          if (cursor != null) Query.cursorAfter(cursor),
          Query.orderDesc('createdAt'),
        ],
      );

      return documents.documents
          .map((doc) => MenuItem.fromJson(_appwrite.documentToJson(doc)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches menu information such as total items and availability.
  Future<MenuInfo> fetchMenuInfo() async {
    try {
      final items = await fetchItems(limit: 2000);

      if (items.length > 1000) {
        return Isolate.run(() => _getMenuInfo(items));
      }

      return _getMenuInfo(items);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  MenuInfo _getMenuInfo(List<MenuItem> items) {
    final totalItems = items.length;
    final availableItems = items.where((item) => item.isAvailable).length;
    final unavailableItems = totalItems - availableItems;

    return MenuInfo(
      totalItems: totalItems,
      availableItems: availableItems,
      unavailableItems: unavailableItems,
    );
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

  String _getFileId(String filename) {
    return filename.split('.').first;
  }

  Future<void> _checkMenuAvailability(String menuId) async {
    try {
      await _appwrite.executeFunction(
        endpoint: _availabilityEndpoint,
        data: {'menuId': menuId, 'databaseId': _projectInfo.databaseId},
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
