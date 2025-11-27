import 'package:flutter/material.dart';

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

  /// Returns the color associated with this log action.
  Color get color {
    switch (this) {
      case LogAction.create:
        return Colors.green;
      case LogAction.update:
        return Colors.blue;
      case LogAction.delete:
        return Colors.red;
    }
  }

  /// Returns the icon for this log action.
  IconData get icon {
    switch (this) {
      case LogAction.create:
        return Icons.add_rounded;
      case LogAction.update:
        return Icons.edit_rounded;
      case LogAction.delete:
        return Icons.delete_rounded;
    }
  }
}
