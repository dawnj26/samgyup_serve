/// A data model for holding appwrite project information.
class ProjectInfo {
  /// Creates a new [ProjectInfo] instance.
  ProjectInfo({
    required this.endpoint,
    required this.projectId,
    required this.projectName,
    required this.databaseId,
    required this.inventoryCollectionId,
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
}
