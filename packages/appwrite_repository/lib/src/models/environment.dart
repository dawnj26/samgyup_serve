/// {@template environment}
/// Represents the environment configuration for Appwrite.
/// Contains the public endpoint, project ID, and project name.
/// {@endtemplate}
class Environment {
  /// Creates an instance of [Environment].
  const Environment({
    required this.appwritePublicEndpoint,
    required this.appwriteProjectId,
    required this.appwriteProjectName,
    required this.databaseId,
    required this.inventoryCollectionId,
    required this.menuCollectionId,
    required this.menuIngredientsCollectionId,
    required this.storageBucketId,
  });

  /// The public endpoint of the Appwrite server.
  final String appwritePublicEndpoint;

  /// The ID of the Appwrite project.
  final String appwriteProjectId;

  /// The name of the Appwrite project.
  final String appwriteProjectName;

  /// The ID of database
  final String databaseId;

  /// The ID of inventory collection.
  final String inventoryCollectionId;

  /// The ID of menu collection.
  final String menuCollectionId;

  /// The ID of menu ingredients collection.
  final String menuIngredientsCollectionId;

  /// The ID of storage bucket.
  final String storageBucketId;
}
