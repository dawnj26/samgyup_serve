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

  /// Fetches all inventory items.
  Future<List<InventoryItem>> fetchInventoryItems() async {
    try {
      final documents = await _appwrite.databases.listDocuments(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.inventoryCollectionId,
      );

      return documents.documents.map((doc) {
        return InventoryItem.fromJson(doc.data);
      }).toList();
    } on AppwriteException catch (e) {
      throw Exception('Failed to fetch inventory items: ${e.message}');
    }
  }

  /// Adds a new inventory item.
  Future<InventoryItem> addInventoryItem(InventoryItem item) async {
    try {
      final documentId = ID.unique();

      final document = await _appwrite.databases.createDocument(
        databaseId: _projectInfo.databaseId,
        collectionId: _projectInfo.inventoryCollectionId,
        documentId: documentId,
        data: item.copyWith(id: documentId).toJson(),
      );

      return InventoryItem.fromJson(document.data);
    } on AppwriteException catch (e) {
      throw Exception('Failed to add inventory item: ${e.message}');
    }
  }
}
