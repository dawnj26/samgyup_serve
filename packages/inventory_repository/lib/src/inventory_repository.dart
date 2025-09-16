import 'dart:isolate';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:inventory_repository/src/enums/enums.dart';
import 'package:inventory_repository/src/models/models.dart';

/// {@template inventory_repository}
/// A repository for managing inventory data.
/// {@endtemplate}
class InventoryRepository {
  /// {@macro inventory_repository}
  InventoryRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance {
    _projectInfo = _appwrite.getProjectInfo();
  }

  final AppwriteRepository _appwrite;
  late final ProjectInfo _projectInfo;

  /// Fetches a list of inventory items.
  ///
  /// This method retrieves all inventory items from the database.
  /// It supports pagination by allowing a [lastDocumentId] to fetch items
  /// after a specific document, and a [limit] to control the number of items
  /// returned in a single call.
  ///
  /// Returns a list of [InventoryItem] objects.
  Future<List<InventoryItem>> fetchItems({
    String? lastDocumentId,
    int? limit,
    InventoryItemStatus? status,
    InventoryCategory? category,
    List<String>? itemIds,
  }) async {
    try {
      String? statusQuery;
      if (status != null) {
        if (status == InventoryItemStatus.expired) {
          statusQuery = Query.lessThanEqual(
            'expirationDate',
            DateTime.now().toIso8601String(),
          );
        } else {
          statusQuery = Query.equal('status', status.name);
        }
      }

      final queries = [
        if (lastDocumentId != null) Query.cursorAfter(lastDocumentId),
        if (statusQuery != null) statusQuery,
        if (category != null) Query.equal('category', category.name),
        if (itemIds != null && itemIds.isNotEmpty) Query.equal(r'$id', itemIds),
        Query.limit(limit ?? 500),
      ];
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      return response.rows.map((row) {
        final json = _appwrite.rowToJson(row);
        return InventoryItem.fromJson(json);
      }).toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch inventory items: $e');
    }
  }

  /// Fetches a list of expired inventory items.
  Future<List<InventoryItem>> fetchExpiredItems({
    String? lastDocumentId,
    int? limit,
  }) async {
    try {
      final queries = [
        if (lastDocumentId != null) Query.cursorAfter(lastDocumentId),
        Query.greaterThanEqual(
          'expirationDate',
          DateTime.now().toIso8601String(),
        ),
        Query.limit(limit ?? 2000),
      ];
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      return response.rows.map((row) {
        final json = _appwrite.rowToJson(row);
        return InventoryItem.fromJson(json);
      }).toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch expired items: $e');
    }
  }

  /// Adds a new inventory item.
  Future<InventoryItem> addItem(InventoryItem item) async {
    try {
      final rowId = ID.unique();
      final status = _getInventoryStatus(item);

      final row = await _appwrite.databases.createRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: rowId,
        data: item
            .copyWith(
              id: rowId,
              status: status,
            )
            .toJson(),
      );

      final json = _appwrite.rowToJson(row);

      return InventoryItem.fromJson(json);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to add inventory item: $e');
    }
  }

  /// Gets inventory information such as total items, in-stock items,
  /// low-stock items, out-of-stock items, and expired items.
  ///
  /// Returns an [InventoryInfo] object containing the inventory statistics.
  Future<InventoryInfo> getInventoryInfo() async {
    try {
      final documents = await fetchItems();

      if (documents.length > 1000) {
        return Isolate.run(() {
          return _queryInventoryInfo(documents);
        });
      } else {
        return _queryInventoryInfo(documents);
      }
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to get inventory info: $e');
    }
  }

  /// Deletes an inventory item by its ID.
  Future<void> deleteItem(String itemId) async {
    try {
      await _appwrite.databases.deleteRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: itemId,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to delete inventory item: $e');
    }
  }

  /// Updates an existing inventory item.
  Future<InventoryItem> updateItem(InventoryItem item) async {
    try {
      final status = _getInventoryStatus(item);

      final document = await _appwrite.databases.updateRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: item.id,
        data: item.copyWith(status: status).toJson(),
      );

      final json = _appwrite.rowToJson(document);

      return InventoryItem.fromJson(json);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to update inventory item: $e');
    }
  }

  InventoryInfo _queryInventoryInfo(List<InventoryItem> items) {
    final totalItems = items.length;
    final inStockItems = items
        .where(
          (item) => item.status == InventoryItemStatus.inStock,
        )
        .length;
    final lowStockItems = items
        .where((item) => item.status == InventoryItemStatus.lowStock)
        .length;
    final outOfStockItems = items
        .where((item) => item.status == InventoryItemStatus.outOfStock)
        .length;
    final expiredItems = items.where((item) => item.isExpired).length;

    return InventoryInfo(
      totalItems: totalItems,
      inStockItems: inStockItems,
      lowStockItems: lowStockItems,
      outOfStockItems: outOfStockItems,
      expiredItems: expiredItems,
    );
  }

  InventoryItemStatus _getInventoryStatus(InventoryItem item) {
    if (item.isOutOfStock) {
      return InventoryItemStatus.outOfStock;
    } else if (item.isLowStock) {
      return InventoryItemStatus.lowStock;
    } else {
      return InventoryItemStatus.inStock;
    }
  }
}
