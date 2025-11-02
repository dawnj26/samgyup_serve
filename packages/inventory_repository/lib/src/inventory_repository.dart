import 'dart:isolate';
import 'dart:math' as math;

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

  String get _batchCollectionId => _appwrite.environment.batchCollectionId;

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
    bool includeBatches = false,
  }) async {
    try {
      String? statusQuery;
      if (status != null) {
        statusQuery = Query.equal('status', status.name);
      }

      final queries = [
        if (lastDocumentId != null) Query.cursorAfter(lastDocumentId),
        ?statusQuery,
        if (category != null) Query.equal('category', category.name),
        if (itemIds != null && itemIds.isNotEmpty) Query.equal(r'$id', itemIds),
        Query.limit(limit ?? 500),
      ];
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      final items = <InventoryItem>[];
      for (final row in response.rows) {
        final json = _appwrite.rowToJson(row);
        var item = InventoryItem.fromJson(json);

        if (includeBatches) {
          final batches = await fetchBatches(itemId: item.id);

          item = item.copyWith(
            stockBatches: batches,
          );
        }

        items.add(item);
      }

      return items;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch inventory items: $e');
    }
  }

  /// Fetches a list of stock batches.
  Future<List<StockBatch>> fetchBatches({
    String? lastDocumentId,
    int? limit,
    String? itemId,
  }) async {
    try {
      final queries = [
        if (lastDocumentId != null) Query.cursorAfter(lastDocumentId),
        if (itemId != null) Query.equal('itemId', itemId),
        Query.limit(limit ?? 500),
      ];
      final response = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _batchCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      return response.rows.map((row) {
        final json = _appwrite.rowToJson(row);
        return StockBatch.fromJson(json);
      }).toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch stock batches: $e');
    }
  }

  /// Adds a new stock batch.
  Future<StockBatch> addBatch(StockBatch batch) async {
    try {
      final rowId = ID.unique();

      final row = await _appwrite.databases.createRow(
        databaseId: _projectInfo.databaseId,
        tableId: _batchCollectionId,
        rowId: rowId,
        data: batch
            .copyWith(
              id: rowId,
            )
            .toJson(),
      );

      final json = _appwrite.rowToJson(row);

      return StockBatch.fromJson(json);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to add stock batch: $e');
    }
  }

  /// Deletes a stock batch by its ID.
  Future<void> deleteBatch(String batchId) async {
    try {
      await _appwrite.databases.deleteRow(
        databaseId: _projectInfo.databaseId,
        tableId: _batchCollectionId,
        rowId: batchId,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to delete stock batch: $e');
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

  /// Syncs a single inventory item by updating its status based on its stock.
  Future<InventoryItem> syncItem(InventoryItem item) async {
    try {
      final status = _getInventoryStatus(item);

      if (item.status == status) {
        return item;
      }

      final document = await _appwrite.databases.updateRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: item.id,
        data: item.copyWith(status: status).toJson(),
      );

      final json = _appwrite.rowToJson(document);

      return InventoryItem.fromJson(json);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to sync inventory item: $e');
    }
  }

  /// Syncs the inventory by updating the status
  /// of each item based on its stock.
  Future<void> syncInventory() async {
    try {
      final inventory = await fetchItems(
        includeBatches: true,
      );

      for (final item in inventory) {
        final status = _getInventoryStatus(item);

        if (item.status != status) {
          await updateItem(
            item.copyWith(
              status: status,
            ),
          );
        }
      }
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to sync inventory: $e');
    }
  }

  /// Fetches a single inventory item by its ID.
  Future<InventoryItem> fetchItemById(
    String itemId, {
    bool includeBatch = false,
  }) async {
    try {
      final document = await _appwrite.databases.getRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: itemId,
      );

      final json = _appwrite.rowToJson(document);

      final item = InventoryItem.fromJson(json);

      if (includeBatch) {
        final batches = await fetchBatches(itemId: item.id);

        return item.copyWith(
          stockBatches: batches,
        );
      }

      return item;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch inventory item: $e');
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

  /// Decrements the stock of an inventory item by a specified quantity.
  Future<void> decrementStock({
    required String itemId,
    required double quantity,
  }) async {
    try {
      final batches = await fetchBatches(itemId: itemId);
      final totalStock = batches.fold<double>(
        0,
        (previousValue, element) {
          if (element.expirationDate == null ||
              element.expirationDate!.isAfter(DateTime.now())) {
            return previousValue + element.quantity;
          }

          return previousValue;
        },
      );

      if (totalStock < quantity) {
        return;
      }

      final sortedBatches = _sortBatchesByExpiry(batches);
      var remainingQuantity = quantity;

      for (final batch in sortedBatches) {
        if (remainingQuantity <= 0) {
          break;
        }

        final deductQuantity = math.min(batch.quantity, remainingQuantity);
        final newQuantity = math
            .min(batch.quantity - deductQuantity, 0)
            .toDouble();

        await _appwrite.databases.updateRow(
          databaseId: _projectInfo.databaseId,
          tableId: _batchCollectionId,
          rowId: batch.id,
          data: batch.copyWith(quantity: newQuantity).toJson(),
        );
        remainingQuantity -= deductQuantity;
      }
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to decrement stock: $e');
    }
  }

  List<StockBatch> _sortBatchesByExpiry(
    List<StockBatch> batches, {
    bool includeExpired = false,
  }) {
    final now = DateTime.now();
    final availableBatches =
        batches
            .where(
              (b) =>
                  b.quantity > 0 &&
                  (includeExpired ||
                      b.expirationDate == null ||
                      b.expirationDate!.isAfter(now)),
            )
            .toList()
          ..sort((a, b) {
            // Items without expiry go last
            if (a.expirationDate == null) return 1;
            if (b.expirationDate == null) return -1;
            // Sort by expiration date (earliest first)
            return a.expirationDate!.compareTo(b.expirationDate!);
          });

    return availableBatches;
  }

  /// Increments the stock of an inventory item by a specified quantity.
  Future<void> incrementStock({
    required String itemId,
    required int quantity,
  }) async {
    // TODO(stock): implement increment stock using FEFO

    try {
      await _appwrite.databases.incrementRowColumn(
        databaseId: _appwrite.environment.databaseId,
        tableId: _projectInfo.inventoryCollectionId,
        rowId: itemId,
        column: 'stock',
        value: quantity.toDouble(),
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to increment stock: $e');
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
    return InventoryInfo(
      totalItems: totalItems,
      inStockItems: inStockItems,
      lowStockItems: lowStockItems,
      outOfStockItems: outOfStockItems,
    );
  }

  InventoryItemStatus _getInventoryStatus(InventoryItem item) {
    final totalStock = item.getAvailableStock();

    if (totalStock <= 0) {
      return InventoryItemStatus.outOfStock;
    } else if (totalStock <= item.lowStockThreshold) {
      return InventoryItemStatus.lowStock;
    } else {
      return InventoryItemStatus.inStock;
    }
  }
}
