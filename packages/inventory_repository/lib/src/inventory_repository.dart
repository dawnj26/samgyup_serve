import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
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
  Future<List<InventoryItem>> fetchInventoryItems({
    String? lastDocumentId,
    int? limit,
    InventoryItemStatus? status,
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
        Query.limit(limit ?? 500),
      ];
      final documents = await _appwrite.databases.listDocuments(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.inventoryCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      return documents.documents.map((doc) {
        final json = _appwrite.documentToJson(doc);
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
        Query.limit(limit ?? 500),
      ];
      final documents = await _appwrite.databases.listDocuments(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.inventoryCollectionId,
        queries: queries.isEmpty ? null : queries,
      );

      return documents.documents.map((doc) {
        final json = _appwrite.documentToJson(doc);
        return InventoryItem.fromJson(json);
      }).toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    } on Exception catch (e) {
      throw Exception('Failed to fetch expired items: $e');
    }
  }

  /// Adds a new inventory item.
  Future<InventoryItem> addInventoryItem(InventoryItem item) async {
    try {
      final documentId = ID.unique();
      final status = _getInventoryStatus(item);

      final document = await _appwrite.databases.createDocument(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.inventoryCollectionId,
        documentId: documentId,
        data: item
            .copyWith(
              id: documentId,
              status: status,
            )
            .toJson(),
      );

      return InventoryItem.fromJson(document.data);
    } on AppwriteException catch (e) {
      throw Exception('Failed to add inventory item: ${e.message}');
    }
  }
}
