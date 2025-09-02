import 'dart:io';
import 'dart:isolate';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:menu_repository/menu_repository.dart';

/// {@template menu_repository}
/// Repository package for managing menu data.
/// {@endtemplate}
class MenuRepository {
  /// {@macro menu_repository}
  MenuRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  ProjectInfo get _projectInfo => _appwrite.getProjectInfo();
  String get _availabilityEndpoint =>
      'https://68aed0320022a720ec79.syd.appwrite.run';
  String get _ingredientBulkEndpoint =>
      'https://68b14af7003e3eb10829.syd.appwrite.run';

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

      await _appwrite.databases.createRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        rowId: m.id,
        data: m.toJson(),
      );

      if (ingredients.isNotEmpty) {
        await _bulkAddIngredients(ingredients, m.id);
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
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        queries: [
          if (category != null && category.isNotEmpty)
            Query.equal('category', category.map((e) => e.name).toList()),
          Query.limit(limit),
          if (cursor != null) Query.cursorAfter(cursor),
          Query.orderDesc('createdAt'),
        ],
      );

      return response.rows
          .map((row) => MenuItem.fromJson(_appwrite.rowToJson(row)))
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

  /// Fetches ingredients for a specific menu item.
  Future<List<Ingredient>> fetchIngredients(String menuItemId) async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuIngredientsCollectionId,
        queries: [
          Query.equal('menuItemId', menuItemId),
          Query.orderAsc('name'),
        ],
      );

      return response.rows
          .map((row) => Ingredient.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Deletes a menu item by its ID.
  Future<void> deleteMenu(String menuId) async {
    try {
      await _appwrite.databases.deleteRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        rowId: menuId,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Updates ingredients for a specific menu item.
  Future<void> updateIngredients({
    required List<Ingredient> ingredients,
    required String menuId,
  }) async {
    try {
      await _bulkDeleteIngredients(menuId);
      if (ingredients.isNotEmpty) {
        await _bulkAddIngredients(ingredients, menuId);
      }
      await _checkMenuAvailability(menuId);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches a specific menu item by its ID.
  Future<MenuItem> fetchItem(String menuId) async {
    try {
      final response = await _appwrite.databases.getRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        rowId: menuId,
      );

      return MenuItem.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches multiple menu items by their IDs.
  Future<List<MenuItem>> fetchItemsByIds(List<String> menuIds) async {
    try {
      if (menuIds.isEmpty) return [];

      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        queries: [
          Query.equal(r'$id', menuIds),
          Query.limit(1000),
        ],
      );

      return response.rows
          .map((row) => MenuItem.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Updates a menu item along with its image if provided.
  Future<MenuItem> updateMenu({
    required MenuItem menu,
    File? imageFile,
  }) async {
    try {
      var imageFileName = menu.imageFileName;
      if (imageFile != null) {
        imageFileName = await _appwrite.uploadFile(imageFile);
      }

      final m = menu.copyWith(
        imageFileName: imageFileName,
      );

      final menuDocument = await _appwrite.databases.updateRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.menuCollectionId,
        rowId: m.id,
        data: m.toJson(),
      );

      await _checkMenuAvailability(m.id);

      return MenuItem.fromJson(_appwrite.rowToJson(menuDocument));
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

  Future<void> _bulkDeleteIngredients(String menuId) async {
    try {
      await _appwrite.executeFunction(
        endpoint: _ingredientBulkEndpoint,
        data: {
          'method': 'delete',
          'data': [Query.equal('menuItemId', menuId)],
        },
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  Future<void> _bulkAddIngredients(
    List<Ingredient> ingredients,
    String menuId,
  ) async {
    try {
      final data = ingredients.map(
        (i) {
          final ingredient = i.copyWith(
            menuItemId: menuId,
            id: ID.unique(),
          );
          return {
            r'$id': ingredient.id,
            ...ingredient.toJson(),
          };
        },
      ).toList();
      await _appwrite.executeFunction(
        endpoint: _ingredientBulkEndpoint,
        data: {
          'method': 'add',
          'data': data,
        },
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
