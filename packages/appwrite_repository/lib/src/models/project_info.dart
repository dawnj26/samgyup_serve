/// A data model for holding appwrite project information.
class ProjectInfo {
  /// Creates a new [ProjectInfo] instance.
  ProjectInfo({
    required this.endpoint,
    required this.projectId,
    required this.projectName,
  });

  /// The public endpoint of the Appwrite server.
  final String endpoint;

  /// The ID of the Appwrite project.
  final String projectId;

  /// The name of the Appwrite project.
  final String projectName;
}
