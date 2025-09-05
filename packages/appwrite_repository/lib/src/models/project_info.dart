/// A data model for holding appwrite project information.
class ProjectInfo {
  /// Creates a new [ProjectInfo] instance.
  const ProjectInfo({
    required this.endpoint,
    required this.projectId,
    required this.projectName,
    required this.databaseId,
    required this.inventoryCollectionId,
    required this.menuCollectionId,
    required this.menuIngredientsCollectionId,
    required this.storageBucketId,
    required this.packageCollectionId,
    required this.tableCollectionId,
  });

  /// The public endpoint of the Appwrite server.
  final String endpoint;

  /// The ID of the Appwrite project.
  final String projectId;

  /// The name of the Appwrite project.
  final String projectName;

  /// The ID of the database.
  final String databaseId;

  /// The ID of the inventory collection.
  final String inventoryCollectionId;

  /// The ID of the menu collection.
  final String menuCollectionId;

  /// The ID of the menu ingredients collection.
  final String menuIngredientsCollectionId;

  /// The ID of the storage bucket.
  final String storageBucketId;

  /// The ID of the package collection.
  final String packageCollectionId;

  /// The ID of the table collection.
  final String tableCollectionId;
}
