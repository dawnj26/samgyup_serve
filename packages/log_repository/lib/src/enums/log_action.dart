/// Enum representing the type of action performed in a log entry.
enum LogAction {
  /// Creation of a new resource.
  create,

  /// Modification of an existing resource.
  update,

  /// Deletion of a resource.
  delete;

  /// Returns the human-readable label for this log action.
  String get label {
    switch (this) {
      case LogAction.create:
        return 'Create';
      case LogAction.update:
        return 'Update';
      case LogAction.delete:
        return 'Delete';
    }
  }
}
